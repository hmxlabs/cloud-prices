
function Get-AzVmPrice($region, $sku)
{
    $pricesObject = [PSCustomObject]@{
        Region = $region
        Sku = $sku
        WindowsSpotPrice = $null
        WindowsOnDemandPrice = $null
        LinuxSpotPrice = $null
        LinuxOnDemandPrice = $null
    }

    $queryFilter = "serviceName eq 'Virtual Machines' and armRegionName eq '$region' and armSkuName eq '$sku' and priceType eq 'Consumption'"
    $prices = Invoke-RestMethod -Uri "https://prices.azure.com/api/retail/prices?`$filter=$queryFilter" -Method Get -ContentType "application/json" -UseBasicParsing
    foreach ($price in $prices.Items)
    {
        if ($price.productName -like "*Windows*")
        {
            if ($price.meterName -like "*Spot*")
            {
                $pricesObject.WindowsSpotPrice = $price.unitPrice
            }
            else
            {
                $pricesObject.WindowsOnDemandPrice = $price.unitPrice
            }
        }
        else
        {
            if ($price.meterName -like "*Spot*")
            {
                $pricesObject.LinuxSpotPrice = $price.unitPrice
            }
            else
            {
                $pricesObject.LinuxOnDemandPrice = $price.unitPrice
            }
        }
    }
    return $pricesObject
}