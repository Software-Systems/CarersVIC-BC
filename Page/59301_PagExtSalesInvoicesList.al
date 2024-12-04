pageextension 59301 "Sales Invoice List Ext" extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addafter("No.")
        {
            field("Invoice Delivery Method"; Rec."Invoice Delivery Method")
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            action(ImportSalesDocuments)
            {
                Caption = 'Import Sales Documents';
                ApplicationArea = All;
                Image = Import;
                trigger OnAction()
                var
                    ExcelBuffer: Record "Excel Buffer";

                begin
                    ReadExcelSheet();
                    ImportExcelData();
                end;
            }
        }
    }

    Procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    procedure ImportExcelData()
    var
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
        QtyInt: Decimal;
        UnitPriceExGSTDec: Decimal;
        AmountExGSTDec: Decimal;
        TaxAmountDec: Decimal;
        TotAmountDec: Decimal;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesLine1: Record "Sales Line";
        PostingDate: Date;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;

        LineNo := 10000;
        TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            //LineNo := LineNo + 10000;
            SalesHeader.Reset();
            If SalesHeader.Get(SalesHeader."Document Type"::Invoice, GetValueAtCell(RowNo, 3)) then begin

                SalesLine1.Reset();
                SalesLine1.SetRange("Document Type", SalesLine1."Document Type"::Invoice);
                SalesLine1.SetRange("Document No.", SalesHeader."No.");
                if SalesLine1.FindLast() then;

                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine.validate("Document No.", GetValueAtCell(RowNo, 3));
                SalesLine.Validate("Line No.", SalesLine1."Line No." + 10000);
                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", GetValueAtCell(RowNo, 11));
                SalesLine.Validate(Description, GetValueAtCell(RowNo, 10));
                Evaluate(QtyInt, GetValueAtCell(RowNo, 5));
                SalesLine.Validate(Quantity, QtyInt);
                Evaluate(UnitPriceExGSTDec, GetValueAtCell(RowNo, 6));
                SalesLine.Validate(SalesLine."Unit Price", UnitPriceExGSTDec);
                Evaluate(TaxAmountDec, GetValueAtCell(RowNo, 8));
                if TaxAmountDec = 0 then begin
                    SalesLine.Validate(SalesLine."VAT Prod. Posting Group", 'GST FREE');
                    SalesLine.Validate(SalesLine."Gen. Prod. Posting Group", 'GST FREE');
                end else begin
                    SalesLine.Validate(SalesLine."VAT Prod. Posting Group", 'GST10');
                    SalesLine.Validate(SalesLine."Gen. Prod. Posting Group", 'GST');
                end;
                SalesLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                SalesLine.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                SalesLine.Insert(true);

            end else begin
                SalesHeader.Init();
                SalesHeader."Document Type" := SalesHeader."Document Type"::Invoice;
                SalesHeader.Validate("No.", GetValueAtCell(RowNo, 3));
                SalesHeader.Insert(true);
                SalesHeader.Validate("Sell-to Customer No.", GetValueAtCell(RowNo, 1));
                SalesHeader.Validate("Sell-to Customer Name", GetValueAtCell(RowNo, 2));
                Evaluate(PostingDate, GetValueAtCell(RowNo, 4));
                SalesHeader.Validate("Posting Date", PostingDate);
                SalesHeader.Validate("Document Date", PostingDate);
                //SalesHeader.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                //SalesHeader.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                SalesHeader.Validate("Imported record", true);
                SalesHeader.Modify(true);

                SalesLine.Init();
                SalesLine."Document Type" := SalesLine."Document Type"::Invoice;
                SalesLine.validate("Document No.", GetValueAtCell(RowNo, 3));
                SalesLine.Validate("Line No.", 10000);
                SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
                SalesLine.Validate("No.", GetValueAtCell(RowNo, 11));
                SalesLine.Validate(Description, GetValueAtCell(RowNo, 10));
                Evaluate(QtyInt, GetValueAtCell(RowNo, 5));
                SalesLine.Validate(Quantity, QtyInt);
                Evaluate(UnitPriceExGSTDec, GetValueAtCell(RowNo, 6));
                SalesLine.Validate(SalesLine."Unit Price", UnitPriceExGSTDec);
                Evaluate(TaxAmountDec, GetValueAtCell(RowNo, 8));
                if TaxAmountDec = 0 then begin
                    SalesLine.Validate(SalesLine."VAT Prod. Posting Group", 'GST FREE');
                    SalesLine.Validate(SalesLine."Gen. Prod. Posting Group", 'GST FREE');
                end else begin
                    SalesLine.Validate(SalesLine."VAT Prod. Posting Group", 'GST10');
                    SalesLine.Validate(SalesLine."Gen. Prod. Posting Group", 'GST');
                end;
                SalesLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                SalesLine.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                SalesLine.Insert(true);
            end;



        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    var
        FileName: Text[100];
        SheetName: Text[100];
        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        ExcelImportSucess: Label 'Excel is successfully imported.';

}