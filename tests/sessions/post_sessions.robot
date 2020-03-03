*** Settings ***				
Resource    ../../resources/services.robot

*** Test Cases ***
New Session
    [tags]      smoke
    &{payload}=         Create Dictionary   email=fernando@papito.io

    ${response}=        Post Session    ${payload}
    ${code}=            Convert To String       ${response.status_code}

    Should Be Equal     ${code}      200

Wrong Email
    &{payload}=         Create Dictionary   email=fernando&papito.io

    ${response}=        Post Session    ${payload}
    ${code}=            Convert To String       ${response.status_code}

    Should Be Equal     ${code}     409

Empty Email
    &{payload}=         Create Dictionary   email=${EMPTY}

    ${response}=        Post Session    ${payload}
    ${code}=            Convert To String       ${response.status_code}

    Should Be Equal     ${code}     412


Without Data
    &{payload}=         Create Dictionary

    ${response}=        Post Session    ${payload}
    ${code}=            Convert To String       ${response.status_code}

    Should Be Equal     ${code}     412
