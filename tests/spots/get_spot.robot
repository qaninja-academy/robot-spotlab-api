
*** Settings ***				
Resource    ../../resources/services.robot

# Dado que tenho um spot cadastrado
# Quando eu faço uma busca pelo Id
# Então o spot deve ser retornado na consulta

*** Test Cases ***
Get Unique Spot
    Set Token        fernando@marvel.com

    &{my_spot}=     Create Dictionary       company=Marvel Unique   techs=java  price=15    user=${token}

    ${spot_id}=     Insert Unique Spot      ${my_spot}
    ${response}=    Get Spot By Id          ${spot_id}

    ${code}=        Convert To String       ${response.status_code}

    Should Be Equal                     ${code}     200
    Dictionary Should Contain Value     ${response.json()}      ${my_spot.company}

# Dado que o id do spot não está cadastrado no sistema
# Quando eu faço a busca pelo id
# Então deve retornar not found 404

Spot Not Found
    ${spot_id}=     Get Mongo Id
    ${response}=    Get Spot By Id          ${spot_id}
    ${code}=        Convert To String       ${response.status_code}

    Should Be Equal                     ${code}     404

Filter Spots
    Set Token        papito@marvel.com

    Hard Reset      ${token}
    Save Spot List  filter.json

    ${response}=    Get Spot By Filter      lua
    ${code}=        Convert To String       ${response.status_code}

    Should Be Equal                     ${code}     200
    Should Not Be Empty                 ${response.json()}
    Dictionary Should Contain Item      ${response.json()[0]}      company     Acme X
    Dictionary Should Contain Item      ${response.json()[1]}      company     Yahoo X

    ${total}=           Get Length              ${response.json()}
    ${total}=           Convert To String       ${total}
    Should Be Equal     ${total}      2