table 71357861 "RelatedPartyNameMapping_VSL"
{
    Caption = 'Related-Party Name Mapping';


    fields
    {
        // field(1; Id_VSL; Integer)
        // {
        //     Caption = 'ID';
        //     DataClassification = CustomerContent;
        //     AutoIncrement = true;
        // }
        field(2; "Related-Party Name_VSL"; text[100])
        {
            Caption = 'Related-Party Name';
            DataClassification = CustomerContent;
        }
        field(3; "Account type_VSL"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Account Type_VSL" <> xRec."Account Type_VSL" then
                    Validate("Account No._VSL", '');
            end;
        }
        field(4; "Account No._VSL"; Code[20])
        {
            Caption = 'Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Account Type_VSL" = CONST("G/L Account")) "G/L Account" WHERE("Account Type" = CONST(Posting),
                                                                                          Blocked = CONST(false))
            ELSE
            IF ("Account Type_VSL" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type_VSL" = CONST(Vendor)) Vendor
            ELSE
            IF ("Account Type_VSL" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type_VSL" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type_VSL" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Account Type_VSL" = CONST(Employee)) Employee;
        }
        field(5; "Bank account No._VSL"; Code[20])
        {
            Caption = 'Bank account No.';
            DataClassification = CustomerContent;
        }
        field(6; "Statement No._VSL"; Code[20])
        {
            Caption = 'Statement No.';
            DataClassification = CustomerContent;
        }



    }

    keys
    {
        key(PK; "Related-Party Name_VSL", "Account type_VSL", "Bank account No._VSL", "Account No._VSL")
        { }
    }
}