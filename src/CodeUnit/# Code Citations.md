# Code Citations

## License: unknown
https://github.com/aayushsb7/QuestUpgrade-master/tree/b8e1bfb05f84260445e2ba69059bf0a2ba58c138/src/REportal/Rep50003.PostAndPrintVoucher.al

```
100) MOD 100) DIV 10;
    OnesDec := (No * 100) MOD 10;
    IF TensDec >= 2 THEN BEGIN
        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
        IF OnesDec > 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[
```


## License: unknown
https://github.com/narsinghnsingh/UCICustomizationOnBase/tree/0a4d77f30ebb9a8386c03998398d98ca87b6545a/.vscode/Reports/Report%2050011%20-%20Sales%20VAT%20Invoice.al

```
* 100) MOD 10;
    IF TensDec >= 2 THEN BEGIN
        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
        IF OnesDec > 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
    END ELSE
        IF (TensDec * 10 + OnesDec
```


## License: unknown
https://github.com/Sravan097714/ENL-Payment-Jnl-Project/tree/d7cedf419220e656dd17faa290a93d61922b36e5/Report/Report_50037_CheckLaserPrinter.al

```
BEGIN
        AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[TensDec]);
        IF OnesDec > 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
    END ELSE
        IF (TensDec * 10 + OnesDec) > 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent,
```


## License: unknown
https://github.com/aayushsb7/QuestUpgrade-master/tree/b8e1bfb05f84260445e2ba69059bf0a2ba58c138/src/CODEUNITAL/Cod50000.IRDMgt.al

```
(NoText, NoTextIndex, PrintExponent, OnesText[OnesDec]);
    END ELSE
        IF (TensDec * 10 + OnesDec) > 0 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[TensDec * 10 + OnesDec])
        ELSE
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text026);
```

