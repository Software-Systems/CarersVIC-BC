report 50105 "Payment Journal Approval"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    Caption = 'CarersVIC Payment Journal Approval';
    RDLCLayout = './Report/CarersVICPaymentJournalApproval.rdl';


    dataset
    {
        dataitem(PaymentFileData; "Payment File Data")
        {
            column(CompanyInfoPicture; CompanyInfo.Picture)
            { }
            column(Vendor_Bank_Account; "Vendor Bank Account")
            { }
            column(Vendor_Name; "Vendor Name")
            { }
            column(Amount; Amount)
            { }
            column(Date; TODAY)
            { }
            column(Comp_Bank_Account_Name; "Comp Bank Account Name")
            { }
            column(Journal_Batch_Name; "Journal Batch Name")
            { }
            column(Vendor_Bank_Branch; "Vendor Bank Branch")
            { }
            column(Posting_Date; "Posting Date")
            { }
            dataitem(TotalDt; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1));
                ;
                column(Total; Total)
                { }
            }
            trigger OnAfterGetRecord()
            var
            begin
                Total += PaymentFileData.Amount;
            end;
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(CompanyInfo.Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        Total: Decimal;
}