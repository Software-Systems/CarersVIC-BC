pageextension 50132 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Dispute Status")
        {
            field("Imported record"; Rec."Imported record")
            {
                ApplicationArea = all;
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