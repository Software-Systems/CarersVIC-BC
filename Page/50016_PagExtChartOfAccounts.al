pageextension 50016 "Chart Of Accounts Ext" extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("A&ccount")
        {
            action("CR Credit Card Reconcilliation")
            {
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLEntry: Record "G/L Entry";
                begin
                    GLEntry.Reset;
                    GLEntry.Setrange(GLEntry."G/L Account No.", Rec."No.");
                    if GLEntry.FindFirst() then
                        Report.Run(Report::"CR Credit Card Reconcilliation", True, True, GLEntry);
                end;
            }
        }
        addafter("Receivables-Payables_Promoted")
        {
            actionref(CCReconcilliation_Promoted; "CR Credit Card Reconcilliation")
            {

            }
        }
    }

    var
        myInt: Integer;
}