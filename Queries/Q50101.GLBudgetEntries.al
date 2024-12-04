
query 50101 "GL Budget Entries"
{
    Caption = 'GL Budget Entries';

    elements
    {
        dataitem(G_L_Budget_Entry; "G/L Budget Entry")
        {
            column(Entry_No; "Entry No.")
            {
            }
            column(Budget_Name; "Budget Name")
            {
            }
            column(G_L_Account_No; "G/L Account No.")
            {
            }
            column(Business_Unit_Code; "Business Unit Code")
            {
            }
            column(Date; Date)
            {
            }
            column(Amount; Amount)
            {
            }
            column(Dimension_Set_ID; "Dimension Set ID")
            {
            }
            column(Cost_Centre; "Global Dimension 1 Code")
            {

            }
            column(Funding_Source; "Global Dimension 2 Code")
            {

            }
            column(Program_Code; "Budget Dimension 1 Code")
            {

            }
        }
    }
}

