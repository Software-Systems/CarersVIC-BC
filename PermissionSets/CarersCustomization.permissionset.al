permissionset 50100 "Carers VIC"
{
    Assignable = true;
    Permissions = tabledata "Payment File Data" = RIMD,
        table "Payment File Data" = X,
        report "CarersVIC Purchase - Invoice" = X,
        report "CarersVIC Purchase - Order" = X,
        report "CarersVIC Sales - Invoice" = X,
        report "CarersVIC Statement" = X,
        report "Payment Journal Approval" = X,
        report "Remittance Advice - Jrnl" = X,
        report "Carer Remitt. Adv Email Body" = X,
        report "CarersVIC Remitt. Adv. Posted" = X,
        report "CR Credit Card Reconcilliation" = X,
        codeunit "CU for Purchase Subscriber" = X,
        codeunit "CU for Sales Subscriber" = X,
        query "GL Budget Entries" = X,
        query "GL Entries" = X;
}