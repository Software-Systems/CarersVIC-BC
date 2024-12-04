pageextension 50039 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        modify(CreateFile)
        {
            Visible = false;
        }
        modify(CreateFile_Promoted)
        {
            Visible = false;
        }
        modify(CancelExport)
        {
            Visible = false;
        }
        modify(CancelExport_Promoted)
        {
            Visible = false;
        }
        addafter(Reconcile)
        {
            action(CreateABAPaymentFile)
            {
                Caption = 'Create ABA Payment File';
                ApplicationArea = all;

                trigger OnAction()
                var
                begin
                    GeneratePaymentFileData();
                    GenerateTextData();
                    GenerateFile();
                end;
            }

        }
        addafter(CalculatePostingDate)
        {
            action(PaymentJournalApprovalReport)
            {
                Caption = 'Approval Report';
                ApplicationArea = all;

                trigger OnAction()
                var
                    PaymentFile: Record "Payment File Data";
                begin
                    GeneratePaymentFileData();
                    Report.RunModal(50105, false, false);
                    if PaymentFile.FindSet() then
                        PaymentFile.DeleteAll();
                end;
            }
        }
        addafter(Reconcile_Promoted)
        {
            Actionref(CreateABAPaymentFile_Promoted; CreateABAPaymentFile)
            {

            }
        }
        addafter(CalculatePostingDate_Promoted)
        {
            Actionref(PaymentJournalApprovalReport_Promoted; PaymentJournalApprovalReport)
            { }
        }
    }
    procedure GeneratePaymentFileData()
    var
        GenJnlLine: Record "Gen. Journal Line";
        vendBankAcc: Record "Vendor Bank Account";
        vendor: Record Vendor;
        PaymentFile: Record "Payment File Data";
        PaymentFile1: Record "Payment File Data";
        PaymentFile2: Record "Payment File Data";
        BankAccount: Record "Bank Account";
        EntryNo: Integer;
    begin
        PaymentFile.DeleteAll();
        GenJnlLine.Reset();
        GenJnlLine.SetCurrentKey("Account No.");
        GenJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
        if GenJnlLine.FindSet() then
            repeat
                if vendor.Get(GenJnlLine."Account No.") then;
                if vendor."EFT Bank Account No." = '' then
                    Error('Please specify the EFT Bank Account No. for Vendor %1', vendor."No.");
                if vendBankAcc.Get(vendor."No.", vendor."EFT Bank Account No.") then;
                if vendBankAcc."Bank Account No." = '' then
                    Error('Please specify the Bank Account No. on Vendor Bank Account %1', vendor."EFT Bank Account No.");
                if vendBankAcc."Bank Branch No." = '' then
                    Error('Please specify the Bank Branch No. on Vendor Bank Account %1', vendor."EFT Bank Account No.");
                if BankAccount.Get(Rec."Bal. Account No.") then;
                PaymentFile.Reset();
                PaymentFile.SetRange("Vendor No.", GenJnlLine."Account No.");
                if not PaymentFile.FindFirst() then begin
                    if PaymentFile2.FindLast() then
                        EntryNo := PaymentFile2."Entry No." + 1
                    else
                        EntryNo := 1;
                    PaymentFile1.Init();
                    PaymentFile1."Entry No." := EntryNo;
                    PaymentFile1."Vendor No." := GenJnlLine."Account No.";
                    PaymentFile1.Amount := GenJnlLine.Amount;
                    PaymentFile1."Vendor Name" := vendor.Name;
                    PaymentFile1."Vendor Bank Branch" := vendBankAcc."Bank Branch No.";
                    PaymentFile1."Vendor Bank Account" := vendBankAcc."Bank Account No.";
                    PaymentFile1."Journal Batch Name" := GenJnlLine."Journal Batch Name";
                    PaymentFile1."Comp Bank Account Name" := BankAccount.Name;
                    PaymentFile1."Posting Date" := GenJnlLine."Posting Date";
                    PaymentFile1.Insert();
                end else begin
                    PaymentFile.Amount += GenJnlLine.Amount;
                    PaymentFile.Modify();
                end;

            until GenJnlLine.Next() = 0;
    end;

    procedure GenerateFile()
    var
        Tempblob: Codeunit "Temp Blob";
        InS: InStream;
        OutS: OutStream;
        FileName: Text;
        TxtBuilder: TextBuilder;
        compInfo: Record "Company Information";
        PaymentFile: Record "Payment File Data";
        DateText: Text;
        YearText: Text;
        MonthText: Text;
        DayText: Text;

    begin

        YearText := COPYSTR(FORMAT(DATE2DMY(Today, 3)), 3, 2);

        IF STRLEN(FORMAT(DATE2DMY(Today, 2))) = 1 THEN
            MonthText := '0' + FORMAT(DATE2DMY(Today, 2))
        ELSE
            MonthText := FORMAT(DATE2DMY(Today, 2));

        IF STRLEN(FORMAT(DATE2DMY(Today, 1))) = 1 THEN
            DayText := '0' + FORMAT(DATE2DMY(Today, 1))
        ELSE
            DayText := FORMAT(DATE2DMY(Today, 1));

        DateText := DayText + MonthText + YearText;

        TotalAmountText := AppendSpace(DelChr(DelChr((Format(TotalAmount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ','), 10, StrLen(DelChr(DelChr((Format(TotalAmount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ',')), 2);

        FileName := 'Payment_' + UserId + '_' + Format(CurrentDateTime) + '.ABA';
        compInfo.get();
        PaymentFile.Reset();
        TxtBuilder.AppendLine('0                 01CRU       Carers Victoria           048875Pay Bills   ' + DateText + '                                        ');
        if PaymentFile.FindSet() then
            repeat
                TxtBuilder.AppendLine(PaymentFile."Payment File Text");
            until PaymentFile.Next() = 0;
        TxtBuilder.AppendLine('7999-999            ' + TotalAmountText + TotalAmountText + '0000000000                        ' + AppendSpace(Format(TotalLine), 6, StrLen(Format(TotalLine)), 2) + '                                        ');
        TempBlob.CreateOutStream(OutS);
        OutS.WriteText(TxtBuilder.ToText());
        TempBlob.CreateInStream(InS);
        DownloadFromStream(InS, '', '', '', FileName);

        Message('Done');
        PaymentFile.DeleteAll();
    end;

    procedure GenerateTextData()
    var
        paymentfileIns: Record "Payment File Data";
        TextData: Text[500];
    begin
        TotalAmount := 0;
        TotalLine := 0;
        if paymentfileIns.FindSet() then
            repeat
                TextData := '1' + paymentfileIns."Vendor Bank Branch" + AppendSpace(paymentfileIns."Vendor Bank Account", 9, StrLen(paymentfileIns."Vendor Bank Account"), 0) + ' 50' + AppendSpace(DelChr(DelChr((Format(paymentfileIns.Amount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ','), 10, StrLen(DelChr(DelChr((Format(paymentfileIns.Amount, 0, '<Integer><Decimals,3>')), '=', '.'), '=', ',')), 2) + AppendSpace(CopyStr(paymentfileIns."Vendor Name", 1, 32), 32, StrLen(CopyStr(paymentfileIns."Vendor Name", 1, 32)), 1) + '                  313-140 23191695Carers Victoria 00000000';
                paymentfileIns."Payment File Text" := TextData;
                paymentfileIns.Modify();
                TotalAmount += paymentfileIns.Amount;
                TotalLine += 1;
            until paymentfileIns.Next() = 0;
    end;

    procedure AppendSpace(Data: Text; TotalLen: Integer; CurrLen: Integer; LeftOrRight: Integer) ReturnData: Text
    var
        Difference: Integer;
        I: Integer;
    begin
        Difference := TotalLen - CurrLen;

        for I := 1 to difference do begin
            if LeftOrRight = 0 then // To append Space on Left
                Data := ' ' + Data;
            if LeftOrRight = 1 then // To append Space on Right
                Data := Data + ' ';
            if LeftOrRight = 2 then // To append Zero on Left
                Data := '0' + Data;
        end;
        exit(Data);
    end;

    var
        TotalAmount: Decimal;
        TotalLine: Integer;
        TotalAmountText: Text;
}