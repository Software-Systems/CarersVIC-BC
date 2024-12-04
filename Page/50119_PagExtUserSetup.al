pageextension 50119 "User Setup Ext" extends "User Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Allow Posting To")
        {
            field("Send email for Vendor changes"; Rec."Send email for Vendor changes")
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