object DMExCh: TDMExCh
  Height = 750
  Width = 1000
  PixelsPerInch = 120
  object FDExCh: TFDConnection
    Params.Strings = (
      'DriverID=SQLite'
      
        'Database=C:\Users\Skopas\Documents\Embarcadero\Studio\Projects\t' +
        'est\exchoperation.db')
    FetchOptions.AssignedValues = [evAutoClose]
    LoginPrompt = False
    BeforeConnect = FDExChBeforeConnect
    Left = 456
    Top = 128
  end
  object FDQueryEXCh: TFDQuery
    Connection = FDExCh
    Transaction = FDTransaction1
    UpdateTransaction = FDTransaction1
    FetchOptions.AssignedValues = [evAutoClose]
    SQL.Strings = (
      'select * from operations'
      '')
    Left = 664
    Top = 160
    object FDQueryEXChID: TFDAutoIncField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object FDQueryEXChtimestamp: TWideMemoField
      FieldName = 'timestamp'
      Origin = 'timestamp'
      BlobType = ftWideMemo
    end
    object FDQueryEXChCurrencyFromN: TWideMemoField
      FieldName = 'CurrencyFromN'
      Origin = 'CurrencyFromN'
      BlobType = ftWideMemo
    end
    object FDQueryEXChCurrencyTo: TWideMemoField
      FieldName = 'CurrencyTo'
      Origin = 'CurrencyTo'
      BlobType = ftWideMemo
    end
    object FDQueryEXChCurrencyFromRate: TFloatField
      FieldName = 'CurrencyFromRate'
      Origin = 'CurrencyFromRate'
    end
    object FDQueryEXChCurrencyToRate: TFloatField
      FieldName = 'CurrencyToRate'
      Origin = 'CurrencyToRate'
    end
    object FDQueryEXChAmountFrom: TFloatField
      FieldName = 'AmountFrom'
      Origin = 'AmountFrom'
    end
    object FDQueryEXChAmountTo: TFloatField
      FieldName = 'AmountTo'
      Origin = 'AmountTo'
    end
  end
  object FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink
    Left = 736
    Top = 328
  end
  object FDTransaction1: TFDTransaction
    Connection = FDExCh
    Left = 368
    Top = 256
  end
end
