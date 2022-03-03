# Ostorlab CI for GithubAction
![Ostorlab CI for GithubAction](https://i.ibb.co/XF3cwWw/image.png)
    
Easily Integrate Ostorlab autonomous security testing for Android and iOS mobile apps to your build process on GitHub actions.

## Summary
Powered by static taint analysis, 3rd party dependencies fingerprinting and vulnerability analysis, dynamic instrumentation and novel backend scanning capabilities, Ostorlab leads the way providing the most advanced vulnerability detection capabilities.

To get more information visit us at https://www.ostorlab.co

## Example  of usage  
```yaml   
on: [push]  
jobs:
   ostorlab_test:
   	runs-on: ubuntu-latest
   	name: Test ostorlab ci actions.
   	steps:
   	 - uses: actions/checkout@v2
   	 - name: Lunch Ostorlab scan
   	   id: start_scan
   	   uses: actions/ostorlab_actions@v1
   		with:
   		 plan: rapid_static 
   		 asset_type: android-apk 
   		 target: myApp.apk

   		 can_title: title_scan_ci
   		 ostorlab_api_key: ${{ secrets.ostorlab_api_key }} # your secret api key.
   		 break_on_risk_rating: HIGH 
   		 max_wait_minutes: 20 
```   
    
## Getting Started

### How to get *API key*   


1. Go to the [API keys menu](https://report.ostorlab.co/library/api/)
2. Click the new button to generate a new key
3. Copy the api key (You can add a name and an expiry date to your key)
4. Click the save button to save your key
 (You can add a name and an expiry date to your key), do not forget to click the save button to save your key.

![api key](https://github.com/jenkinsci/ostorlab-plugin/raw/master/images/jenkins-apikey.png)

To add your api key to GitHub actions check the following link [Github:Creating encrypted secrets for a repository](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

    
### Action inputs    
    
 - **`plan`** *(['rapid_static', 'static_dynamic_backend'])*: [Required] - Specifies your scan plan ( free (rapid_static) for community scans and static_dynamic_backend for full analysis).
- **`asset_type`** *(['android-apk', 'android-aab', 'ios-ipa'])*: [Required] -Type of scan.    
- **`target`**: [Required] - target file to scan.    
- **`ostorlab_api_key`**: [Required] -  Api key from ostorlab.     
- **`scan_title`**: [Optional] - Specifies the scan title.
- **`break_on_risk_rating`** *(['HIGH', 'MEDIUM', 'LOW','POTENTIALLY])*: [Optional] -  wait for the scan results and force the action to fail if the scan risk rating match or higher this value.    
- **`max_wait_minutes`**: [Optional] - Specifies the maximum number of minutes to wait for scan results.

### More details   
- [ostorlab.co](https://www.ostorlab.co/)  
- [Risk Ratings](https://docs.ostorlab.co/guide/#risk-ratings)  
- [Ostorlab SDK](https://github.com/ostorlab/ostorlab)