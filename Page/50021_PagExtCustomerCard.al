pageextension 50021 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("E-Mail")
        {
            field("Invoice Recipient Email"; Rec."Invoice Recipient Email")
            {
                ApplicationArea = all;
            }
        }
        addafter("Bill-to Customer No.")
        {
            field("Invoice Delivery method"; Rec."Invoice Delivery method")
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



