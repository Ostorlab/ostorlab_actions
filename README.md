# Ostorlab ci_scan github action
Run ostorlab scan as  a GitHub action.

## Example
```yaml
on: [push]
jobs:
  custom_test: 
    runs-on: ubuntu-latest 
    name: Test ostorlab ci actions.
    steps: 
      - uses: actions/checkout@v2 
      - name: Lunch Ostorlab scan 
        id: start_scan 
        uses: actions/github_actions_ci@v1 
        with: 
          plan: free # Specify which plan to use for the scan (check plan section) .  
          asset_type: android # type of asset to scan. 
          target: andoird_apk # target for the scan.  
          scan_title: title_scan_ci # type a title for your scan.  
          ostorlab_api_key: ${{ secrets.ostorlab_api_key }} # your secret api key.  
          break_on_risk_rating: HIEGHT # optional force the action to fail if the scan risk.   
          max_wait_minutes: 2 # maximum time to wait for scan results before failing. 
```