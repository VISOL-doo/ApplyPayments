tableextension 71357860 "BankAccReccLine_VSL" extends "Bank Acc. Reconciliation Line"
{

    fields
    {
        field(71357860; "Add to mapping_VSL"; Boolean)
        {
            Caption = 'Add to mapping';
            DataClassification = CustomerContent;
        }
        field(71357861; "Match Confidence_VSL"; Option)
        {

            CalcFormula = Max("Applied Payment Entry"."Match Confidence" WHERE("Statement Type" = FIELD("Statement Type"),
                                                                                "Bank Account No." = FIELD("Bank Account No."),
                                                                                "Statement No." = FIELD("Statement No."),
                                                                                "Statement Line No." = FIELD("Statement Line No.")));
            Caption = 'Match Confidence';
            //DataClassification = CustomerContent;
            Editable = false;
            FieldClass = FlowField;
            InitValue = "None";
            OptionCaption = 'None,Low,Medium,High,High - Text-to-Account Mapping,Manual,Accepted,Related-party Name Mapping';
            OptionMembers = "None",Low,Medium,High,"High - Text-to-Account Mapping",Manual,Accepted,"Related-party Name Mapping";

        }

        field(71357862; "Account No._VSL"; Code[20])
        {
            Caption = 'Loacal Acount No.';
            DataClassification = CustomerContent;
        }


    }

    // procedure TransferRemainingAmountToAccoun_VSL(BankAccRec: Record "Bank Acc. Reconciliation Line")
    // var
    //     AppliedPaymentEntry: Record "Applied Payment Entry";
    // begin
    //     TestField("Account No.");

    //     SetAppliedPaymentEntryFromRec_VSL(AppliedPaymentEntry, BankAccRec);
    //     AppliedPaymentEntry.Validate("Applied Amount", BankAccRec.Difference);
    //     AppliedPaymentEntry.Validate("Match Confidence", AppliedPaymentEntry."Match Confidence"::"High - Text-to-Account Mapping");
    //     AppliedPaymentEntry.Insert(true);
    // end;

    // local procedure SetAppliedPaymentEntryFromRec_VSL(var AppliedPaymentEntry: Record "Applied Payment Entry"; BankAccRec: Record "Bank Acc. Reconciliation Line")
    // begin
    //     AppliedPaymentEntry.TransferFromBankAccReconLine(BankAccRec);
    //     AppliedPaymentEntry."Account Type" := "Gen. Journal Account Type".FromInteger(GetAppliedToAccountType());
    //     AppliedPaymentEntry."Account No." := GetAppliedToAccountNo();
    //     AppliedPaymentEntry."Document No." := format(GetAppliedToDocumentNo());
    // end;
}