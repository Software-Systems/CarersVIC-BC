reportextension 50211 RepExtCustomerPaymentReceipt extends "Customer - Payment Receipt"
{
    dataset
    {
        add(PageLoop)
        {
            column(CompInfoPicture; CompInfo.Picture)
            {
            }
        }
        modify("Cust. Ledger Entry")
        {
            trigger OnBeforePreDataItem()
            begin
                Setfilter("Document Type", '%1|%2|%3', "Document Type"::" ", "Document Type"::Payment, "Document Type"::Refund);
                if CustNo <> '' then
                    Setrange("Customer No.", CustNo);
                if DocNo <> '' then
                    SetFilter("Document No.", DocNo);
            end;
        }
    }

    rendering
    {
        layout(RDL)
        {
            Type = RDLC;
            Caption = 'CV Customer Payment Receipt';
            Summary = 'CV Customer Payment Receipt';
            LayoutFile = 'Report/Layout/CarersVICCustomerPaymentReceipt.rdl';
        }
    }
    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(CompInfo.Picture)
    end;

    var
        CompInfo: Record "Company Information";
        CustNo: Text;
        DocNo: Text;

    procedure SetPar(ParEntryNo: Text)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.Reset;
        CustLedgerEntry.SetFilter(CustLedgerEntry."Entry No.", ParEntryNo);
        if CustLedgerEntry.findset then begin
            repeat
                CustNo := CustLedgerEntry."Customer No.";
                DocNo := DocNo + CustLedgerEntry."Document No." + '|';
            until CustLedgerEntry.Next = 0;
            if DocNo <> '' then
                DocNo := CopyStr(DocNo, 1, StrLen(DocNo) - 1);
        end;
    end;
}
