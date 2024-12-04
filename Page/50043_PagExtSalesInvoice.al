pageextension 50043 "Sales Invoice Ext" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
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