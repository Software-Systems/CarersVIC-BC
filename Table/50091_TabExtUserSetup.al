tableextension 50091 "User Setup Ext" extends "User Setup"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Send email for Vendor changes"; Boolean)
        {
            Caption = 'Send email for Vendor changes';
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}