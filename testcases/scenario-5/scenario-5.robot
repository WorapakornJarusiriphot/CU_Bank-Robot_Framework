*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${BROWSER}    Chrome
${URL}    http://localhost:3000/
${ACCOUNT_ID}    1234567890
${PASSWORD}    1234

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5s

Login
    [Arguments]    ${account_id}    ${password}
    Input Text    id=accountId    ${account_id}
    Input Text    id=password    ${password}
    Click Button    xpath=//button[@cid="lc"]
    Wait Until Element Contains    xpath=//h2    Account ID:

Deposit Amount
    [Arguments]    ${amount}
    Input Text    xpath=//input[@cid="d1"]    ${amount}
    Click Button    xpath=//button[@cid="dc"]
    Sleep    1s

Withdraw Amount
    [Arguments]    ${amount}
    Input Text    xpath=//input[@cid="w1"]    ${amount}
    Click Button    xpath=//button[@cid="wc"]
    Sleep    1s

Transfer Amount
    [Arguments]    ${target_account}    ${amount}
    Input Text    xpath=//input[@cid="t1"]    ${target_account}
    Input Text    xpath=//input[@cid="t2"]    ${amount}
    Click Button    xpath=//button[@cid="tc"]

*** Test Cases ***
# Scenario 5 : Login ผ่าน ตามด้วย การฝากเงินที่ผ่าน ถอนเงินผ่าน และ โอนเงินไม่ผ่าน (ใส่เลขบัญชีที่จะรับเงินโอนผิด)
Test Scenario 5: Login Deposit Withdraw pass Transfer fail
    Login    ${ACCOUNT_ID}    ${PASSWORD}
    Deposit Amount    1000
    Withdraw Amount    500
    Transfer Amount    0987654322    200
    # Verify transfer failure message
    Page Should Contain Element    xpath=//label[@cid="transfer-error-mes"]    We couldn't find the recipient's account. Please double-check the account ID.
    
