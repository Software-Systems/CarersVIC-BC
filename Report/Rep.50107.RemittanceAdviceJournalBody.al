report 50107 "Carer Remitt. Adv Email Body"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    //WordLayout = './Report/Layout/CarersVICRemitAdvEmailBody.docx';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = sorting("Vendor No.") where("Document Type" = const(Payment));
        }
    }
}