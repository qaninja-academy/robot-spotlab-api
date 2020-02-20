*** Settings ***				
Resource    ../../resources/services.robot

# Dado que eu tenho spots cadastrados
# Quando eu faço uma consulta Get no serviço Dashboard
# Então deve retornar uma lista de spots

*** Test Cases ***
Get my spots on Dashboard
    Set Token        eu@papito.io
    Save Spot List   my_spots.json

    ${response}=     Get My Spots
    ${code}=         Convert To String       ${response.status_code}

    Should Be Equal         ${code}     200
    Log                     ${response.text}
    Should Not Be Empty     ${response.json()}

