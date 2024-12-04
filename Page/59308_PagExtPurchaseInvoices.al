pageextension 59308 "Purchase Invoices Ext" extends "Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter("P&osting")
        {
            action(ImportPurchaseDocuments)
            {
                Caption = 'Import Purchase Documents';
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
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLine1: Record "Purchase Line";
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
            PurchaseHeader.Reset();
            If PurchaseHeader.Get(PurchaseHeader."Document Type"::Invoice, GetValueAtCell(RowNo, 3)) then begin

                PurchaseLine1.Reset();
                PurchaseLine1.SetRange("Document Type", PurchaseLine1."Document Type"::Invoice);
                PurchaseLine1.SetRange("Document No.", PurchaseHeader."No.");
                if PurchaseLine1.FindLast() then;

                PurchaseLine.Init();
                PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
                PurchaseLine.validate("Document No.", GetValueAtCell(RowNo, 3));
                PurchaseLine.Validate("Line No.", PurchaseLine1."Line No." + 10000);
                PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
                PurchaseLine.Validate("No.", GetValueAtCell(RowNo, 11));
                PurchaseLine.Validate(Description, GetValueAtCell(RowNo, 10));
                Evaluate(QtyInt, GetValueAtCell(RowNo, 5));
                PurchaseLine.Validate(Quantity, QtyInt);
                Evaluate(UnitPriceExGSTDec, GetValueAtCell(RowNo, 6));
                PurchaseLine.Validate(PurchaseLine."Direct Unit Cost", UnitPriceExGSTDec);
                Evaluate(TaxAmountDec, GetValueAtCell(RowNo, 8));
                if TaxAmountDec = 0 then begin
                    PurchaseLine.Validate(PurchaseLine."VAT Prod. Posting Group", 'GST FREE');
                    PurchaseLine.Validate(PurchaseLine."Gen. Prod. Posting Group", 'GST FREE');
                end else begin
                    PurchaseLine.Validate(PurchaseLine."VAT Prod. Posting Group", 'GST10');
                    PurchaseLine.Validate(PurchaseLine."Gen. Prod. Posting Group", 'GST');
                end;
                PurchaseLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                PurchaseLine.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                PurchaseLine.Insert(true);

            end else begin
                PurchaseHeader.Init();
                PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Invoice;
                PurchaseHeader.Validate("No.", GetValueAtCell(RowNo, 3));
                PurchaseHeader.Insert(true);
                PurchaseHeader.Validate("Buy-from Vendor No.", GetValueAtCell(RowNo, 1));
                PurchaseHeader.Validate("Buy-from Vendor Name", GetValueAtCell(RowNo, 2));
                Evaluate(PostingDate, GetValueAtCell(RowNo, 4));
                PurchaseHeader.Validate("Posting Date", PostingDate);
                PurchaseHeader.Validate("Document Date", PostingDate);
                PurchaseHeader.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                PurchaseHeader.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                PurchaseHeader.Validate("Vendor Invoice No.", GetValueAtCell(RowNo, 3));
                PurchaseHeader.Validate("Imported record", true);
                PurchaseHeader.Modify(true);

                PurchaseLine.Init();
                PurchaseLine."Document Type" := PurchaseLine."Document Type"::Invoice;
                PurchaseLine.validate("Document No.", GetValueAtCell(RowNo, 3));
                PurchaseLine.Validate("Line No.", 10000);
                PurchaseLine.Validate(Type, PurchaseLine.Type::"G/L Account");
                PurchaseLine.Validate("No.", GetValueAtCell(RowNo, 11));
                PurchaseLine.Validate(Description, GetValueAtCell(RowNo, 10));
                Evaluate(QtyInt, GetValueAtCell(RowNo, 5));
                PurchaseLine.Validate(Quantity, QtyInt);
                Evaluate(UnitPriceExGSTDec, GetValueAtCell(RowNo, 6));
                PurchaseLine.Validate(PurchaseLine."Direct Unit Cost", UnitPriceExGSTDec);
                Evaluate(TaxAmountDec, GetValueAtCell(RowNo, 8));
                if TaxAmountDec = 0 then begin
                    PurchaseLine.Validate(PurchaseLine."VAT Prod. Posting Group", 'GST FREE');
                    PurchaseLine.Validate(PurchaseLine."Gen. Prod. Posting Group", 'GST FREE');
                end else begin
                    PurchaseLine.Validate(PurchaseLine."VAT Prod. Posting Group", 'GST10');
                    PurchaseLine.Validate(PurchaseLine."Gen. Prod. Posting Group", 'GST');
                end;
                PurchaseLine.Validate("Shortcut Dimension 1 Code", GetValueAtCell(RowNo, 12));
                PurchaseLine.Validate("Shortcut Dimension 2 Code", GetValueAtCell(RowNo, 13));
                PurchaseLine.Insert(true);
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