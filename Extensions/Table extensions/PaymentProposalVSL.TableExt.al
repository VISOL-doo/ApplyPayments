tableextension 71357861 "PaymentProposal_VSL" extends "Payment Application Proposal"
{

    fields
    {
        field(71357861; "Ship to name_VSL"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Ship to name';
            //FieldClass = FlowField;
            //CalcFormula = lookup("Sales Invoice Header"."Ship-to Name" WHERE("No." = field("Document No.")));
            TableRelation = if ("Account Type" = const(Customer)) "Sales Invoice Header"."Ship-to Name" WHERE("No." = field("Document No."))
            else
            if ("Account Type" = const(Vendor)) "Purch. Inv. Header"."Ship-to Name" WHERE("No." = field("Document No."));

        }
        field(71357862; "Payment reference_VSL"; Text[100])
        {
            //DataClassification = CustomerContent;
            Caption = 'Payment reference';
            FieldClass = FlowField;
            CalcFormula = lookup("Cust. Ledger Entry"."Payment Reference" WHERE("Entry No." = field("Applies-to Entry No.")));

        }

    }

    trigger OnInsert()
    var
        SalInvHeader: Record "Sales Invoice Header";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin

        if ("Account Type" = "Account Type"::Customer)
        then begin
            //if ("Document No." <> '') then begin
            SalInvHeader.SetRange("No.", "Document No.");
            if SalInvHeader.FindFirst() then
                "Ship to name_VSL" := SalInvHeader."Ship-to Name";
            //end;

        end else
            if ("Account Type" = "Account Type"::Vendor) then begin
                //if ("Document No." <> '') then begin
                PurchInvHeader.SetRange("No.", "Document No.");
                if PurchInvHeader.FindFirst() then
                    "Ship to name_VSL" := PurchInvHeader."Ship-to Name";
                //end;
            end;


    end;
}