pageextension 50138 "Posted Purchase Invoice Ext" extends "Posted Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(Corrective)
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