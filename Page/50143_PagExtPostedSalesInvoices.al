pageextension 50143 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Invoice Delivery Method"; Rec."Invoice Delivery Method")
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