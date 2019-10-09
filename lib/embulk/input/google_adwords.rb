require 'adwords_api'

module Embulk
  module Input

    class GoogleAdwords < InputPlugin
      Plugin.register_input("google_adwords", self)

      def self.transaction(config, &control)
        # configuration code:
        task = {
          "adwords_api_options" => {
            "authentication" => {
              "method" => config.param("auth_method", :string),
              "oauth2_client_id" => config.param("auth_oauth2_client_id", :string),
              "oauth2_client_secret" => config.param("auth_oauth2_client_secret", :string),
              "developer_token" => config.param("auth_developer_token", :string),
              "client_customer_id" => config.param("auth_client_customer_id", :string),
              "user_agent" => config.param("auth_user_agent", :string),
              "oauth2_token" => {
                "access_token" => config.param("oauth2_access_token", :string),
                "refresh_token" => config.param("oauth2_refresh_token", :string),
                "issued_at" => config.param("oauth2_issued_at", :string),
                "expires_in" => config.param("oauth2_expires_in", :string),
                "id_token" => ""
              }
            },
            "service" => {
              "environment" => "PRODUCTION"
            },
            "connection" => {
              "enable_gzip" => false
            },
            "library" => {
              "log_level" => "INFO",
              "skip_report_header" => true,
              "skip_column_header" => true,
              "skip_report_summary" => true
            }
          },
          "report_type" => config.param("report_type", :string),
          "fields" => config.param("fields", :array),
          "conditions" => config.param("conditions", :array, default: []),
          "daterange" => config.param("daterange", :hash, default: {})
        }

        raise ConfigError.new("The parameter report_type must not be empty.") if task["report_type"].empty?
        raise ConfigError.new("The parameter fields must not be empty array.") if task["fields"].empty?

        columns = task["fields"].map do |col_name|
          Column.new(nil, col_name, :string)
        end

        resume(task, columns, 1, &control)
      end

      def self.resume(task, columns, count, &control)
        task_reports = yield(task, columns, count)

        next_config_diff = {}
        return next_config_diff
      end

      # TODO
      # def self.guess(config)
      # end

      def init
        # initialization code:
      end

      def run
        selectors = task["fields"].join(", ")
        conditions = task["conditions"].join(" AND ")

        query = "SELECT " + selectors + " FROM " + task["report_type"]
        query << " WHERE " + conditions unless conditions.empty?
        query << " DURING #{task["daterange"]["min"]},#{task["daterange"]["max"]}" unless task["daterange"].empty?
        begin
          query_report_results(query) do |row|
            page_builder.add row
          end

        # Authorization error.
        rescue AdsCommon::Errors::OAuth2VerificationRequired => e
          raise ConfigError.new(e.message)

        # HTTP errors.
        rescue AdsCommon::Errors::HttpError => e
          raise ConfigError.new(e.message)

        # API errors.
        rescue AdwordsApi::Errors::ReportError => e
          raise ConfigError.new(e.message)
        end

        page_builder.finish

        task_report = {}
        return task_report
      end

      def query_report_results(query, &block)
        # AdwordsApi::Api
        adwords = AdwordsApi::Api.new(task["adwords_api_options"])

        # Get report utilities for the version.
        report_utils = adwords.report_utils

        # Allowing rows with zero impressions to show is not supported with AWQL.
        adwords.include_zero_impressions = false

        report_utils.get_stream_helper_with_awql(query, 'CSV').each_line do |line|
          row = line.split(",")
          block.call row
        end
      end
    end

  end
end
