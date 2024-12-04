pageextension 50051 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter(Status)
        {
            field("Imported record"; Rec."Imported record")
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