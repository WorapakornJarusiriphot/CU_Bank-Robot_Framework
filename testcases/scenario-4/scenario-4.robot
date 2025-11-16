*** Settings ***
Library         SeleniumLibrary
Test Setup      Open Browser To Login Page
Test Teardown   Close Browser

*** Variables ***
${BROWSER}      Chrome
${URL}          http://localhost:3000/
${ACCOUNT_ID}   1234567890
${PASSWORD}     1234

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5s

Login
    [Arguments]    ${account_id}    ${password}
    Input Text      id=accountId    ${account_id}
    Input Text      id=password     ${password}
    Click Button    xpath=//button[@cid="lc"]
    Wait Until Element Contains    xpath=//h2    Account ID:

Deposit Amount
    [Arguments]    ${amount}
    Input Text      xpath=//input[@cid="d1"]    ${amount}
    Click Button    xpath=//button[@cid="dc"]
    Sleep           1s

Withdraw Amount
    [Arguments]    ${amount}
    Input Text      xpath=//input[@cid="w1"]    ${amount}
    Click Button    xpath=//button[@cid="wc"]
    Sleep           1s

Transfer Amount
    [Arguments]    ${target_account}    ${amount}
    Input Text      xpath=//input[@cid="t1"]    ${target_account}
    Input Text      xpath=//input[@cid="t2"]    ${amount}
    Click Button    xpath=//button[@cid="tc"]

*** Test Cases ***
# Scenario 4.1 : Login ผ่าน ตามด้วย การฝากเงินที่ผ่าน และ ถอนเงินที่ไม่ผ่าน
TC4-01: Login Pass, Deposit Pass, Withdraw Fail (Insufficient Funds)
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    100
    Withdraw Amount    200    
    Wait Until Element Contains    xpath=//label[@cid="withdraw-error-mes"]      Your balance is not enough to complete the withdrawal.

TC4-02: Login Pass, Deposit Pass, Withdraw Fail (withdrawAmount = 0)
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    100
    Withdraw Amount    0      
    Wait Until Element Contains    xpath=//label[@cid="withdraw-error-mes"]      The amount must be greater than 0. Please enter a positive number.  

TC4-03: Login Pass, Deposit Pass, Withdraw Fail (withdrawAmount < 0)
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    100
    Withdraw Amount    -1     
    Wait Until Element Contains    xpath=//label[@cid="withdraw-error-mes"]      The amount must be greater than 0. Please enter a positive number.

TC4-04: Login Pass, Deposit Pass, Withdraw Fail (withdrawAmount not integer)
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    100
    Withdraw Amount    20.1
    Wait Until Element Contains    xpath=//label[@cid="withdraw-error-mes"]       The balance amount must be a whole number with no decimals.

TC4-05: Login Pass, Deposit Pass, Withdraw Fail (withdrawAmount have alphabet)
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    100
    Withdraw Amount    500e4          
    Wait Until Element Contains    xpath=//label[@cid="withdraw-error-mes"]       Invalid balance amount. Please enter a valid number. 