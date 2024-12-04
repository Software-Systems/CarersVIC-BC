pageextension 50379 "Bank Acc. Reconciliation Ext" extends "Bank Acc. Reconciliation"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(ImportBankStatement)
        {
            Visible = false;
        }
        addbefore("&Card")
        {
            action(ImportBankStatementCustomized)
            {
                Caption = 'Import Bank Statement';
                ApplicationArea = All;
                trigger OnAction()
                var
                    InS: InStream;
                    FileName: Text[100];
                    UploadMsg: Label 'Please choose the CSV file';
                    Item: Record Item;
                    LineNo: Integer;
                    BankAccRecLine: Record "Bank Acc. Reconciliation Line";
                    BankRecoLineNo: Integer;
                    AmountInt: Decimal;
                    TransDate: Date;


                begin
                    BankRecoLineNo := 10000;
                    BankAccRecLine.Reset();
                    BankAccRecLine.SetRange("Bank Account No.", Rec."Bank Account No.");
                    BankAccRecLine.SetRange("Statement No.", Rec."Statement No.");
                    if BankAccRecLine.FindFirst() then
                        Error('Please Delete Existing Bank Reconciliation Line');
                    CSVBuffer.Reset();
                    CSVBuffer.DeleteAll();
                    if UploadIntoStream(UploadMsg, '', '', FileName, InS) then begin
                        CSVBuffer.LoadDataFromStream(InS, ',');
                        for LineNo := 1 to CSVBuffer.GetNumberOfLines() do begin
                            BankAccRecLine.Init();
                            BankAccRecLine.Validate("Bank Account No.", Rec."Bank Account No.");
                            BankAccRecLine.Validate("Statement No.", Rec."Statement No.");
                            BankAccRecLine."Statement Line No." := BankRecoLineNo;
                            BankAccRecLine.Insert(true);
                            Evaluate(TransDate, GetValueAtCell(LineNo, 2));
                            BankAccRecLine.Validate(BankAccRecLine."Transaction Date", TransDate);
                            BankAccRecLine.Description := CopyStr(GetValueAtCell(LineNo, 3), 1, 100);
                            Evaluate(AmountInt, DelChr(GetValueAtCell(LineNo, 4), '=', '$'));
                            BankAccRecLine.Validate("Statement Amount", AmountInt);
                            BankAccRecLine.Modify(true);
                            BankRecoLineNo := BankRecoLineNo + 10000;
                        end;
                    end;
                    Message('Imported Successfully');
                end;
            }
        }
        addbefore("&Card_Promoted")
        {
            Actionref(ImportBankStatementCustomized_Pramoted; ImportBankStatementCustomized)
            { }
        }
    }

    var
        CSVBuffer: Record "CSV Buffer" temporary;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        if CSVBuffer.Get(RowNo, ColNo) then
            exit(CSVBuffer.Value)
        else
            exit('');
    end;
}