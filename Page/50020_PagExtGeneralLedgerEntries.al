pageextension 50020 "General Ledger Entries Ext" extends "General Ledger Entries"

{
    layout
    {
        // Add changes to page layout here
        addafter("External Document No.")
        {
            field("Recon Period"; Rec."Recon Period")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}