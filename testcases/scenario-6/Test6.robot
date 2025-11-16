*** Settings ***
Library           SeleniumLibrary

*** Variables ***
${LOGIN_URL}    http://localhost:3000
${BROWSER}      chrome
${ACCOUNT_NUMBER}   1234567890
${PASSWORD}     1234
${AMOUNT0}     0
${AMOUNT1}     0
${AMOUNT10000}     10000
${AMOUNTNegative}     -10000
${AMOUNT1000}     1000
${AMOUNTFloat}     1.50
${AMOUNTWrong}     abc

*** Test Cases ***
Amount is empty 6-1
    [Documentation]    EQ1, EQ2, EQ34, EQ40
    Login User
    Click Element   billTarget
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    ${message}=    Execute Javascript    return document.querySelector('[cid="b4"]').validationMessage;
    Should Be Equal     ${message}  Please fill out this field.

Does not click on Water, Electric, or Phone 6-2
    [Documentation]    EQ1, EQ2, EQ35
    Login User
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNT1}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    ${message}=    Execute Javascript    return document.querySelector('[name="billTarget"]').validationMessage;
    Should Be Equal     ${message}  Please select one of these options.

Pay with 0 6-3
    [Documentation]    EQ1, EQ2, EQ34, EQ37B
    Login User
    Sleep           1s
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNT0}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    Page Should Contain    The amount must be greater than 0. Please enter a positive number.

Pay with Negative amount 6-4
    [Documentation]    EQ1, EQ2, EQ34, EQ37A
    Login User
    Sleep           1s
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNTNegative}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    Page Should Contain    The amount must be greater than 0. Please enter a positive number.

Pay with Negative amount 6-5
    [Documentation]    EQ1, EQ2, EQ34, EQ38
    Login User
    Sleep           1s
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNT10000}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    Page Should Contain    Your balance is not enough to complete the bill payment.

Pay with Not round number amount 6-6
    [Documentation]    EQ1, EQ2, EQ34, EQ39
    Login User
    Sleep           1s
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNTFloat}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    Page Should Contain    The balance amount must be a whole number with no decimals.

Pay with Not number amount 6-7
    [Documentation]    EQ1, EQ2, EQ34, EQ40
    Login User
    Sleep           1s
    Click Element   billTarget
    Sleep           1s
    Input Text      css=[cid='b4']        ${AMOUNTWrong}
    Sleep           1s
    Click Element   css=[cid='bc']
    Sleep           1s
    Page Should Contain    Invalid balance amount. Please enter a valid number.


*** Keywords ***

Login User
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Input Text      accountId   ${ACCOUNT_NUMBER}
    Input Text      password        ${PASSWORD}
    Click Element   css=[cid='lc']
    Sleep    1s
    Capture Page Screenshot