pageextension 50025 "Customer Ledger Entries Ext" extends "Customer Ledger Entries"
{
    actions
    {
        addafter(AppliedEntries)
        {
            action("Print Payment Receipt")
            {
                ApplicationArea = All;
                Image = Print;
                trigger OnAction()
                var
                    PaymentReceipt: Report "Customer - Payment Receipt";
                    CLE: Record "Cust. Ledger Entry";
                    EntryNo: Text;
                begin
                    CLE.CopyFilters(Rec);
                    CurrPage.SETSELECTIONFILTER(CLE);
                    if CLE.FindSet() then begin
                        repeat
                            EntryNo := EntryNo + Format(CLE."Entry No.") + '|';
                        until CLE.Next() = 0;
                        if EntryNo <> '' then
                            EntryNo := CopyStr(EntryNo, 1, StrLen(EntryNo) - 1);
                    end;

                    Clear(PaymentReceipt);
                    PaymentReceipt.SetPar(EntryNo);
                    PaymentReceipt.RunModal();
                end;
            }
            action("Send Payment Receipt")
            {
                ApplicationArea = All;
                Image = SendConfirmation;
                trigger OnAction()
                var
                    CLE: Record "Cust. Ledger Entry";
                    EntryNo: Text;
                    CarersVICSendReceipt: Codeunit "Carers VIC Send Receipt";
                begin
                    CLE.CopyFilters(Rec);
                    CurrPage.SETSELECTIONFILTER(CLE);
                    if CLE.FindSet() then begin
                        repeat
                            EntryNo := EntryNo + Format(CLE."Entry No.") + '|';
                        until CLE.Next() = 0;
                        if EntryNo <> '' then
                            EntryNo := CopyStr(EntryNo, 1, StrLen(EntryNo) - 1);
                    end;
                    CarersVICSendReceipt.SendCustomerPaymentReceipt(Rec."Customer No.", EntryNo);
                end;
            }
        }
        addafter(AppliedEntries_Promoted)
        {
            actionref(PrintPaymentReceipt_Promoted; "Print Payment Receipt")
            {
            }
            actionref(SendPaymentReceipt_Promoted; "Send Payment Receipt")
            {
            }
        }
    }
}