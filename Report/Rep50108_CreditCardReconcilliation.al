report 50108 "CR Credit Card Reconcilliation"
{
    ApplicationArea = All;
    Caption = 'Credit Card Reconcilliation';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './Report/CarersVICCreditCardReconcilliation.rdl';
    EnableHyperlinks = true;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(GLEntry; "G/L Entry")
        {
            RequestFilterFields = "G/L Account No.", "G/L Account Name", "Posting Date", "Bal. Account No.", "Bal. Account Name";
            column(WorkDate; WorkDate)
            {
            }
            column(CompanyName; CompanyName)
            {
            }
            column(GLEntryGetFilters; GLEntry.GetFilters)
            {
            }
            column(ShowDetails; ShowDetails)
            {
            }
            column(Amount; Amount)
            {
            }
            column(PostingDate; "Posting Date")
            {
            }
            column(BalAccountNo; "Bal. Account No.")
            {
            }
            column(BalAccountName; GetBalAccName("Bal. Account Type", "Bal. Account No."))
            {
            }
            column(BalAccountType; "Bal. Account Type")
            {
            }
            column(GLAccountName; "G/L Account Name")
            {
            }
            column(GLAccountNo; "G/L Account No.")
            {
            }
            column(DocumentNo; "Document No.")
            {
            }
            column(Description; Description)
            {
            }
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Details';
                    }
                }

            }
        }
    }
    var
        ShowDetails: Boolean;

    local procedure GetBalAccName(ParBalAccType: Enum "Gen. Journal Account Type"; ParBalAccNo: Code[20]) RetValue: Text
    var
        BankAccount: Record "Bank Account";
        GLAccount: Record "G/L Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        FixedAsset: Record "Fixed Asset";
    begin
        case
            ParBalAccType of
            ParBalAccType::"Bank Account":
                begin
                    if BankAccount.Get(ParBalAccNo) then
                        RetValue := BankAccount.Name;
                end;
            ParBalAccType::"G/L Account":
                begin
                    if GLAccount.Get(ParBalAccNo) then
                        RetValue := GLAccount.Name;
                end;
            ParBalAccType::Customer:
                begin
                    if Customer.Get(ParBalAccNo) then
                        RetValue := Customer.Name;
                end;
            ParBalAccType::Vendor:
                begin
                    if Vendor.Get(ParBalAccNo) then
                        RetValue := Vendor.Name;
                end;
            ParBalAccType::"Fixed Asset":
                begin
                    if FixedAsset.Get(ParBalAccNo) then
                        RetValue := FixedAsset.Description;
                end;
        end;
        if RetValue = '' then
            RetValue := 'No Balancing Account.';
        exit(RetValue);
    end;
}