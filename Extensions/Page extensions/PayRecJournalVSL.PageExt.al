pageextension 71357860 "PayRecJournal_VSL" extends "Payment Reconciliation Journal"
{
    PromotedActionCategories = 'New,Process,Report,Manual Application,Review,Details,Show,Page,Posting,Line,Local Application';

    layout
    {
        addafter("Transaction Text")
        {
            field("Add to mapping_VSL"; Rec."Add to mapping_VSL")
            {
                ApplicationArea = all;
                ToolTip = 'Add to mapping';
                Caption = 'Add to mapping';
            }
        }


    }

    actions
    {
        addfirst(navigation)
        {

            group(LocalApplication_VSL)
            {
                Caption = 'Local Application';

                action(SelectAllForRelPartyNameMap_VSL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Select all lines for mapping';
                    ToolTip = 'Select all lines for mapping';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    trigger OnAction()
                    var
                        BankAccReconciliation: Record "Bank Acc. Reconciliation Line";
                    begin
                        BankAccReconciliation.SetRange("Statement No.", Rec."Statement No.");
                        BankAccReconciliation.SetRange("Statement Type", Rec."Statement Type");
                        BankAccReconciliation.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankAccReconciliation.SetFilter("Account No.", '<>%1', '');
                        if BankAccReconciliation.FindSet() then
                            repeat
                                BankAccReconciliation."Add to mapping_VSL" := true;
                                BankAccReconciliation.Modify();
                            until BankAccReconciliation.Next() = 0;
                    end;
                }
                action(ApplyAccountNo_VSL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Map Related-Party Name';
                    ToolTip = 'Map Related-Party Name';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    trigger OnAction()
                    var
                        BankAccReconciliation: Record "Bank Acc. Reconciliation Line";
                        RelatedPartyNameMapping: Record RelatedPartyNameMapping_VSL;
                        RelatedPartyNameMappin2: Record RelatedPartyNameMapping_VSL;
                        Numm: Integer;
                        Success: Boolean;
                    begin
                        BankAccReconciliation.SetRange("Statement No.", Rec."Statement No.");
                        BankAccReconciliation.SetRange("Statement Type", Rec."Statement Type");
                        BankAccReconciliation.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankAccReconciliation.SetFilter("Account No.", '<>%1', '');

                        Success := false;
                        if BankAccReconciliation.FindSet() then
                            repeat
                                if BankAccReconciliation."Add to mapping_VSL" then begin
                                    // RelatedPartyNameMapping.SetFilter("Related-Party Name_VSL", BankAccReconciliation."Related-Party Name");
                                    // RelatedPartyNameMapping.SetRange("Account type_VSL", BankAccReconciliation."Account Type");
                                    // RelatedPartyNameMapping.SetFilter("Account No._VSL", '=%1', BankAccReconciliation."Account No.");
                                    // RelatedPartyNameMapping.SetFilter("Bank account No._VSL", '=%1', BankAccReconciliation."Bank Account No.");
                                    //RelatedPartyNameMapping.Get(BankAccReconciliation."Related-Party Name",BankAccReconciliation."Account Type",BankAccReconciliation."Bank Account No.",BankAccReconciliation."Account No.");
                                    if NOT RelatedPartyNameMappin2.Get(BankAccReconciliation."Related-Party Name", BankAccReconciliation."Account Type", BankAccReconciliation."Bank Account No.", BankAccReconciliation."Account No.") then begin
                                        RelatedPartyNameMapping.Init();
                                        RelatedPartyNameMapping."Account No._VSL" := BankAccReconciliation."Account No.";
                                        RelatedPartyNameMapping."Related-Party Name_VSL" := BankAccReconciliation."Related-Party Name";
                                        RelatedPartyNameMapping."Account type_VSL" := BankAccReconciliation."Account Type";
                                        RelatedPartyNameMapping."Bank account No._VSL" := BankAccReconciliation."Bank Account No.";
                                        RelatedPartyNameMapping."Statement No._VSL" := BankAccReconciliation."Statement No.";
                                        // RelatedPartyNameMapping.Id_VSL := Numm;
                                        RelatedPartyNameMapping.Insert();

                                        RelatedPartyNameMapping."Account No._VSL" := BankAccReconciliation."Account No.";
                                        RelatedPartyNameMapping.Modify();

                                        Success := true
                                    end;


                                end;

                                BankAccReconciliation."Add to mapping_VSL" := false;
                                BankAccReconciliation.Modify();

                            until BankAccReconciliation.Next() = 0;
                        if Success then
                            Message(SuccessfullyMap);

                        if not Success then
                            Message(NotSuccessfullyMap)

                    end;
                }

                action(ApplyAll_VSL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Apply all cust/vend/bank';
                    ToolTip = 'Apply all cust/vend/bank';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    trigger OnAction()
                    var
                        BankAccReconciliation: Record "Bank Acc. Reconciliation";
                        AppliedPaymentEntry: Record "Applied Payment Entry";
                        RelatedPartyNameMapping: Record RelatedPartyNameMapping_VSL;
                        RelatedPartyNameMapp: Record RelatedPartyNameMapping_VSL;
                        ConfirmManagement: Codeunit "Confirm Management";
                        MatchBankPmtAppl: Codeunit "Match Bank Pmt. Appl._VSL";
                        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
                        SetField: Codeunit SetFieldBankPay_VSL;
                        SubscriberInvoked: Boolean;
                        Overwrite: Boolean;
                        Window: Dialog;
                        Counter: Integer;

                    begin

                        BankAccReconLine.SetRange("Statement No.", Rec."Statement No.");
                        BankAccReconLine.SetRange("Statement Type", Rec."Statement Type");
                        BankAccReconLine.SetRange("Bank Account No.", Rec."Bank Account No.");
                        BankAccReconLine.SetRange("Account No.", '');
                        Counter := 0;
                        Window.Open(MatchingStLinesMsg);
                        if BankAccReconLine.FindSet() then
                            repeat
                                Counter += 1;
                                RelatedPartyNameMapping.SetFilter("Related-Party Name_VSL", '=%1', BankAccReconLine."Related-Party Name");
                                RelatedPartyNameMapping.SetFilter("Bank account No._VSL", '=%1', BankAccReconLine."Bank Account No.");

                                if RelatedPartyNameMapping.FindFirst() then begin
                                    //Message(RelatedPartyNameMapping."Related-Party Name_VSL");
                                    Window.Update(1, StrSubstNo(ProcessedStmtLinesMsg, Counter, BankAccReconLine.Count));
                                    Window.Update(2, Round(Counter / BankAccReconLine.Count * 10000, 1));
                                    BankAccReconLine.validate("Account Type", RelatedPartyNameMapping."Account type_VSL");
                                    BankAccReconLine.Modify();
                                    BankAccReconLine.validate("Account No.", RelatedPartyNameMapping."Account No._VSL");
                                    BankAccReconLine.Modify();
                                    BankAccReconLine."Account No." := BankAccReconLine."Account No.";
                                    BankAccReconLine.Modify();
                                    BankAccReconLine.validate("Account No._VSL", RelatedPartyNameMapping."Account No._VSL");
                                    BankAccReconLine.Modify();

                                    if BankAccReconLine.Difference <> 0 then begin
                                        BankAccReconLine.TransferRemainingAmountToAccount();
                                        BankAccReconLine.Modify();
                                    end;

                                    BankAccReconLine.Validate("Applied Amount", BankAccReconLine.Difference);
                                    BankAccReconLine.Modify();

                                    BankAccReconLine."Match Confidence_VSL" := BankAccReconLine."Match Confidence_VSL"::"Related-party Name Mapping";

                                    BankAccReconLine.Modify();
                                end else begin
                                    RelatedPartyNameMapp.SetFilter("Related-Party Name_VSL", '=%1', BankAccReconLine."Related-Party Name");
                                    RelatedPartyNameMapp.SetFilter("Bank account No._VSL", '=%1', '');
                                    if RelatedPartyNameMapping.FindFirst() then begin
                                        Window.Update(1, StrSubstNo(ProcessedStmtLinesMsg, Counter, BankAccReconLine.Count));
                                        Window.Update(2, Round(Counter / BankAccReconLine.Count * 10000, 1));
                                        BankAccReconLine.validate("Account Type", RelatedPartyNameMapp."Account type_VSL");
                                        BankAccReconLine.Modify();
                                        BankAccReconLine.validate("Account No.", RelatedPartyNameMapp."Account No._VSL");
                                        BankAccReconLine.Modify();
                                        BankAccReconLine."Account No." := BankAccReconLine."Account No.";
                                        BankAccReconLine.Modify();
                                        BankAccReconLine.validate("Account No._VSL", RelatedPartyNameMapp."Account No._VSL");
                                        BankAccReconLine.Modify();

                                        if BankAccReconLine.Difference <> 0 then begin
                                            BankAccReconLine.TransferRemainingAmountToAccount();
                                            BankAccReconLine.Modify();
                                        end;

                                        BankAccReconLine.Validate("Applied Amount", BankAccReconLine.Difference);
                                        BankAccReconLine.Modify();

                                        BankAccReconLine."Match Confidence_VSL" := BankAccReconLine."Match Confidence_VSL"::"Related-party Name Mapping";

                                        BankAccReconLine.Modify();
                                    end;
                                end;
                            until BankAccReconLine.Next() = 0;
                        Window.Close();
                    end;

                }
                action(RelatedPartyNameMapping_VSL)

                {
                    ApplicationArea = Suite;
                    Caption = 'Related-Party Name Mapping';
                    ToolTip = 'Related-Party Name Mapping';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    trigger OnAction()
                    begin
                        Page.Run(Page::RelatedPartyNameMapping_VSL);

                    end;
                }
                // action(ApplyAllLines_VSL)
                // {
                //     ApplicationArea = Suite;
                //     Caption = 'Apply all lines';
                //     ToolTip = 'Apply all lines';
                //     PromotedIsBig = true;
                //     PromotedOnly = true;
                //     Image = "Report";
                //     Promoted = true;
                //     PromotedCategory = Category11;
                //     trigger OnAction()
                //     var
                //         BankAccReconciliation: Record "Bank Acc. Reconciliation";
                //         AppliedPaymentEntry: Record "Applied Payment Entry";
                //         RelatedPartyNameMapping: Record RelatedPartyNameMapping_VSL;
                //         ConfirmManagement: Codeunit "Confirm Management";
                //         MatchBankPmtAppl: Codeunit "Match Bank Pmt. Appl._VSL";
                //         BankAccReconLine: Record "Bank Acc. Reconciliation Line";
                //         SetField: Codeunit SetFieldBankPay_VSL;
                //         SubscriberInvoked: Boolean;
                //         Overwrite: Boolean;
                //     begin

                //         AppliedPaymentEntry.SetRange("Statement Type", Rec."Statement Type");
                //         AppliedPaymentEntry.SetRange("Bank Account No.", Rec."Bank Account No.");
                //         AppliedPaymentEntry.SetRange("Statement No.", Rec."Statement No.");
                //         AppliedPaymentEntry.SetRange("Match Confidence", AppliedPaymentEntry."Match Confidence"::Accepted);
                //         AppliedPaymentEntry.SetRange("Match Confidence", AppliedPaymentEntry."Match Confidence"::Manual);

                //         if AppliedPaymentEntry.Count > 0 then
                //             Overwrite := ConfirmManagement.GetResponseOrDefault(OverwriteExistingMatchesTxt, false)
                //         else
                //             Overwrite := true;

                //         BankAccReconciliation.Get(Rec."Statement Type", Rec."Bank Account No.", Rec."Statement No.");

                //         OnAtActionApplyAutomatically_VSL(BankAccReconciliation, SubscriberInvoked);
                //         if not SubscriberInvoked then
                //             if Overwrite then
                //                 CODEUNIT.Run(CODEUNIT::"Match Bank Pmt. Appl._VSL", BankAccReconciliation)
                //             else
                //                 MatchBankPmtAppl.MatchNoOverwriteOfManualOrAccepted(BankAccReconciliation);
                //         CurrPage.Update(false);
                //     end;
                // }


                action(MatchConfManually_VSL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Match payment application (Shift+F1)';
                    ToolTip = 'Match payment application (Shift+F1)';
                    //ShortcutKey = 'Shift+S';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    ShortcutKey = 'Shift+F1';
                    trigger OnAction()
                    var
                        PaymentApplication: Page PaymentApplication_VSL;
                    begin
                        PaymentApplication.SetBankAccReconcLine(Rec);
                        PaymentApplication.RunModal();
                    end;
                }
                action(ShowDocumentLevel_VSL)
                {
                    ApplicationArea = Suite;
                    Caption = 'Show applied lines without document level';
                    ToolTip = 'Show applied lines without document level';
                    //ShortcutKey = 'Shift+S';
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = Category11;
                    trigger OnAction()
                    var
                        AppliedPaymentEntry: Record "Applied Payment Entry";
                        BankAccRec: Record "Bank Acc. Reconciliation Line";
                        FileteStatLineNo: Text;
                    begin
                        BankAccRec.SetRange("Statement Type", "Statement Type");
                        BankAccRec.SetRange("Bank Account No.", "Bank Account No.");
                        BankAccRec.SetRange("Statement No.", "Statement No.");
                        if BankAccRec.FindSet() then
                            repeat
                                AppliedPaymentEntry.SetRange("Statement Type", BankAccRec."Statement Type");
                                AppliedPaymentEntry.SetRange("Bank Account No.", BankAccRec."Bank Account No.");
                                AppliedPaymentEntry.SetRange("Statement No.", BankAccRec."Statement No.");
                                AppliedPaymentEntry.SetRange("Statement Line No.", BankAccRec."Statement Line No.");
                                //AppliedPaymentEntry.SetRange("Match Confidence", BankAccRec."Match Confidence");
                                AppliedPaymentEntry.SetFilter("Document No.", '=%1', '');
                                if AppliedPaymentEntry.FindFirst() then
                                    FileteStatLineNo += format(BankAccRec."Statement Line No.") + '|';
                            until BankAccRec.Next() = 0;

                        // Message(FileteStatLineNo);
                        SetFilter("Statement Line No.", COPYSTR(FileteStatLineNo, 1, STRLEN(FileteStatLineNo) - 1));
                        SetFilter(Difference, '=0');
                        SetFilter("Account Type", '%1|%2', "Account Type"::Customer, "Account Type"::Vendor);
                        CurrPage.Update();
                    end;
                }
            }
        }
    }

    // [IntegrationEvent(false, false)]
    // procedure OnAtActionApplyAutomatically(BankAccReconciliation: Record "Bank Acc. Reconciliation"; var SubscriberInvoked: Boolean)
    // begin
    // end;

    var
        OverwriteExistingMatchesTxt: Label 'Overwriting previous applications will not affect Accepted and Manual ones.\\Chose Yes to overwrite, or No to apply only new entries.';
        SuccessfullyMap: Label 'Successfully map Related-Party Name with Customer';
        NotSuccessfullyMap: Label 'There is nothing for mapping. Please check the correct line.';
        MatchingStmtLinesMsg: Label 'Please wait while the operation is being completed.';
        MatchingStLinesMsg: Label 'The matching of statement lines to open ledger entries is in progress.\\Please wait while the operation is being completed.\\#1####### @2@@@@@@@@@@@@@';
        ProcessedStmtLinesMsg: Label 'Processed %1 out of %2 lines.';

    [IntegrationEvent(false, false)]
    procedure OnAtActionApplyAutomatically_VSL(BankAccReconciliation: Record "Bank Acc. Reconciliation"; var SubscriberInvoked: Boolean)
    begin
    end;


}