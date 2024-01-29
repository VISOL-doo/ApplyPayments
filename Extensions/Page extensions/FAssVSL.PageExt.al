pageextension 71357862 "FAss_VSL" extends "Fixed Asset Card"
{

    actions
    {
        addafter("C&opy Fixed Asset")
        {
            action(UpdateSubclass_VSL)
            {
                Caption = 'Update Subclass';
                ApplicationArea = All;
                ToolTip = 'Update Subclass';
                Promoted = true;
                PromotedCategory = Process;
                Image = UpdateXML;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                var
                    FAsset: Record "Fixed Asset";
                    ChangeSublass: Report ChangeSubclass_VSL;
                    FilterRec: Text;
                begin
                    FAsset := Rec;
                    Clear(ChangeSublass);
                    CurrPage.SetSelectionFilter(FAsset);

                    if FAsset.FindSet() then
                        repeat
                            FilterRec += FAsset."No." + '|';
                        until FAsset.Next() = 0;
                    FilterRec := copystr(FilterRec, 1, StrLen(FilterRec) - 1);
                    ChangeSublass.SetFixedAsset(FilterRec);
                    ChangeSublass.RunModal();
                end;
            }
        }
    }
}