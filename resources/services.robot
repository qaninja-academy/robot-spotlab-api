*** Settings ***				
Library	    Collections			
Library	    RequestsLibrary
Library     OperatingSystem

Library     ./libs/mongo.py

*** Variables ***
${base_uri}     http://spotlab-api.herokuapp.com

*** Keywords ***
### /sessions
Post Session
    [Arguments]     ${payload}

    Create Session      spotapi  ${base_uri}

    &{headers}=         Create Dictionary   Content-Type=application/json
    ${response}=        Post Request    spotapi     /sessions   data=${payload}     headers=${headers}
    
    [return]            ${response}

Set Token
    [Arguments]     ${email}

    &{payload}      Create Dictionary   email=${email}
    &{headers}=     Create Dictionary   Content-Type=application/json

    ${response}=    Post Session        ${payload}
    ${token}        Convert To String   ${response.json()['_id']}

    Set Suite Variable  ${token}  

### /spots
Save Spot
    [Arguments]    ${payload}  ${thumb}

    Create Session  spotapi     ${base_uri}

    ${file_data}=       Get Binary File     ${CURDIR}/img/${thumb}
    &{files}=           Create Dictionary   thumbnail=${file_data}

    &{headers}=     Create Dictionary   user_id=${token}
    ${response}=    Post Request        spotapi     /spots  files=${files}      data=${payload}     headers=${headers}

    [return]            ${response}

Save Spot Without Image
    [Arguments]     ${payload}

    Create Session  spotapi     ${base_uri}

    &{headers}=     Create Dictionary   user_id=${token}
    ${response}=    Post Request        spotapi     /spots  data=${payload}     headers=${headers}

    [return]        ${response}

Save Spot List
    [Arguments]     ${json_file}

    ${my_spots}=     Get File         resources/fixtures/${json_file}
    ${json}=         Evaluate         json.loads('''${my_spots}''')    json
    ${data}=         Set Variable     ${json['data']}

    :FOR    ${item}     IN      @{data}

    \       ${thumb}=           Get From Dictionary     ${item}         thumb
    \       ${payload}=         Get From Dictionary     ${item}         payload
    \       Save Spot           ${payload}      ${thumb}

Get Spot By Id
    [Arguments]     ${spot_id}

    Create Session  spotapi     ${base_uri}
    &{headers}=     Create Dictionary   user_id=${token}

    ${response}=    Get Request     spotapi     /spots/${spot_id}   headers=${headers}

    [return]        ${response}

Get Spot By Filter
    [Arguments]     ${tech}

    Create Session  spotapi     ${base_uri}

    ${response}=    Get Request     spotapi     /spots?tech=${tech}
    [return]        ${response}

### /dashboard
Get My Spots
    Create Session  spotapi     ${base_uri}

    &{headers}=     Create Dictionary   user_id=${token}
    ${response}=    Get Request     spotapi     /dashboard  headers=${headers}

    [return]        ${response}
