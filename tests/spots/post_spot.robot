*** Settings ***	
Library         OperatingSystem

Resource        ../../resources/services.robot

Suite Setup     Set Token   fernando@qaninja.io
# Suite Teardown  Delete Session  # voce pode criar essa key caso deseja necessário encerrar a sessao na api

*** Test Cases ***
Create a new Spot
    [tags]      smoke
    &{payload}=             Create Dictionary   company=Google  techs=java, golang  price=50
    Remove Spot By Company  ${payload['company']}

    ${response}=        Save Spot               ${payload}   google.jpg
    ${code}=            Convert To String       ${response.status_code}

    Should Be Equal     ${code}      200
    
Create a new Company
    
    ${token}                Get Token           papito@hotmail.com      pass123
    &{payload}=             Create Dictionary   company=Google  techs=java, golang

    &{headers}=     Create Dictionary   user_id=${token}
    ${response}=    Post Request        ${BASE_API}/company      json=${payload}     headers=${headers}

    bla bla bla

Empty Company
    &{payload}=         Create Dictionary   company=${EMPTY}  techs=java, golang  price=50
    ${response}=        Save Spot           ${payload}   google.jpg
    ${code}=            Convert To String   ${response.status_code}

    Should Be Equal     ${code}      412

    ${business_code}=   Convert To Integer  1001

    Should Be Equal                     ${response.json()['code']}  ${business_code}
    Dictionary Should Contain Value     ${response.json()}          ${business_code} 
    Dictionary Should Contain Value     ${response.json()}          Company is required

Empty Technologies
    &{payload}=         Create Dictionary   company=Acme  techs=${EMPTY}  price=50
    ${response}=        Save Spot           ${payload}   acme.jpg
    ${code}=            Convert To String   ${response.status_code}

    Should Be Equal     ${code}      412

    ${business_code}=   Convert To Integer  1002

    Should Be Equal                     ${response.json()['code']}  ${business_code}
    Dictionary Should Contain Value     ${response.json()}          ${business_code} 
    Dictionary Should Contain Value     ${response.json()}          Technologies is required

Empty Thumbnail
    &{payload}=         Create Dictionary           company=Yahoo  techs=java  price=50
    ${response}=        Save Spot Without Image     ${payload}
    ${code}=            Convert To String           ${response.status_code}

    Should Be Equal     ${code}      412
