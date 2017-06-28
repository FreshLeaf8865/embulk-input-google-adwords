# Google AdWords input plugin for Embulk

Embulk input plugin for Google AdWords reports.

## Configuration
### Authentication

- **auth_method**: OAuth2 (Authentication method must be OAuth2 for AdWords API access.)
- **auth_oauth2_client_id**: OAuth2 client ID
- **auth_oauth2_client_secret**: OAuth2 client secret
- **auth_developer_token**: Developer token for AdWords API access
- **auth_client_customer_id**: Account number of the AdWords client account, e.g. 123-456-7890
- **auth_user_agent**: User agent string, e.g. Embulk plugin for Google Adwords
- **oauth2_access_token**: OAuth2 access token
- **oauth2_refresh_token**: OAuth2 refresh token
- **oauth2_issued_at**: The date and time when the OAuth2 access token has been issued
- **oauth2_expires_in**: Expiration duration of OAuth2 access token
### Query
- **report_type**: Report type to query, e.g. CAMPAIGN_PERFORMANCE_REPORT
- **fields**: Field list to query
- **conditions**: Condition list of the query
- **daterange**: Date range of the query
### How to get configuration values
You can check `config.yml.example` file.<br/>
There are links in there.

## Build

```
$ rake
```
