
tableextension 50017 "G/L Entry Ext" extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here
        field(50100; "Recon Period"; Text[100])
        {
            Caption = 'Recon Period';
        }
        field(50110; "Bal. Account Name"; Text[100])
        {
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("G/L Account".Name where("No." = field("Bal. Account No.")));
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
}