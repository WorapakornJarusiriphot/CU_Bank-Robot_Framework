*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${LOGIN_URL}    http://localhost:3000
${BROWSER}      chrome
${ACCOUNT_NUMBER}   1234567890
${PASSWORD}     1234
${AMOUNT0}     0
${AMOUNT10000}     10000
${AMOUNTNegative}     -10000
${AMOUNT1}     1

*** Test Cases ***
Successful Payment 7-1
    [Documentation]    EQ1, EQ2, EQ34, EQ36
    Login User
    Sleep           1s
    Input Text      css=[cid='d1']        ${AMOUNT1}
    Click Element   css=[cid='dc']
    Sleep           1s
    ${current}=        Get Current Balance
    ${expected}=    Evaluate    ${current} - ${AMOUNT1}
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNT1}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    ${current}=        Get Current Balance
    Should Be Equal As Integers    ${current}    ${expected}


*** Keywords ***

Login User
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      accountId   ${ACCOUNT_NUMBER}
    Input Text      password        ${PASSWORD}
    Click Element   css=[cid='lc']
    Sleep    1s
    Capture Page Screenshot

Get Current Balance
    [Documentation]    อ่านค่า Balance จากหน้า UI
    Wait Until Page Contains Element   xpath=//h2[normalize-space(.)="Balance:"]/following-sibling::h1[1]    10s
    ${text}=           Get Text        xpath=//h2[normalize-space(.)="Balance:"]/following-sibling::h1[1]
    ${value}=          Convert To Integer    ${text}
    RETURN             ${value}