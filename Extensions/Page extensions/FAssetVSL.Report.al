report 71357861 "ChangeSubclass_VSL"
{
    Caption = 'Change Subclass';
    Permissions = TableData 5600 = rimd;
    UsageCategory = None;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Fixed Asset"; "Fixed Asset")
        {
            //RequestFilterFields = "No.";
            trigger OnAfterGetRecord()
            var

            begin
                //"Purch. Cr. Memo Hdr.".SetRange("No.", PostedDocNo);
                "Fixed Asset".SetFilter("No.", PostedDocNoFilter);
                if "Fixed Asset".FindSet() then
                    repeat
                        if ChangeSubclass then
                            "Fixed Asset"."FA Subclass Code" := SubClass;

                        "Fixed Asset".Modify();
                    until "Fixed Asset".Next() = 0;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;


        layout
        {
            area(Content)
            {
                group(ChangeSubclassFieldsAccept)
                {
                    Caption = 'Change Subclass Accept';

                    field(ChangeSubclass_VSL; ChangeSubclass)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Change Subclass';
                        ToolTip = 'Change Subclass';
                    }

                }
                group(ChangeSubclassFields)
                {
                    Caption = 'Change Subclass';

                    field(ChangeSubclass; SubClass)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Change Subclass';
                        ToolTip = 'Change Subclass';
                        TableRelation = "FA Subclass".Code;
                    }

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if not ChangeSubclass and not ChangePostedDocumentType then
            Error(Text000Msg);
    end;

    var
        ChangeSubclass: Boolean;
        ChangePostedDocumentType: Boolean;
        SubClass: Code[20];
        PostedDocumentType: Code[20];
        PostedDocNoFilter: Text;

        Text000Msg: Label 'There are nothing to change';

    procedure SetFixedAsset(FixedAsset: Text)
    begin
        PostedDocNoFilter := FixedAsset;
    end;
}