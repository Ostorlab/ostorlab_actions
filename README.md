

# Ostorlab ci_scan github action  
Run ostorlab scan as  a GitHub action.  
  
## Example  of usage
```yaml  
on: [push]  
jobs:  
 custom_test:    runs-on: ubuntu-latest   
    name: Test ostorlab ci actions.  
 steps:      - uses: actions/checkout@v2   
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
  
  
  
## inputs  
  
  
- **`plan`** *(['free', 'plan2', 'plan3'])*: [Required] - Specify which plan to use for scan.  
- **`asset_type`** *(['android', 'ios'])*: [Required] -Type of scan.  
- **`target`**: [Required] - Target to scan.  
- **`ostorlab_api_key`**: [Required] -  Api key from ostorlab.   
- **`scan_title`**: [Optional] -  Title for your scan.  
- **`break_on_risk_rating`**: [Optional] -  Title for your scan.  
- **`max_wait_minutes`**: [Optional] -  Maximum minutes to wait for scan results.

## Plans 
Ostorlab provides a free plan for community users.
you can read more about our plans in the following link  [https://www.ostorlab.co/plans](https://www.ostorlab.co/plans)

## How to get *API key* 

The API key can be retrieved from your [Dashboard -> Library -> API KEY](https://report.ostorlab.co/library/api). 
 Click the new button to generate a new key and copy the API key 
 (You can add a name and an expiry date to your key), do not forget to click the save button to save your key.

## More details 

- [ostorlab.co](https://www.ostorlab.co/)
- [Risk Ratings](https://docs.ostorlab.co/guide/#risk-ratings)
- [Open source version](https://github.com/ostorlab/ostorlab)
