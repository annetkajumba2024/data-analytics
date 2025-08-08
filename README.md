# Uganda R Maps: Analysis and Insights from the 2024 Uganda National Census 

This repository uses R to visualize Uganda's 2024 census data. It contains data, R scripts, and output maps that highlight spatial patterns in population, education, and poverty.

After realizing the power of geospatial data in development decisions, I built this repo to:
- Practice spatial data analysis using R
- Understand population distribution across Uganda
- Identify education disparities using indicators like:
  - Percentage of children aged 3–6 not in school, and children aged 6-17 out of school
  - Youth NEET (Not in Education, Employment, or Training) aged 15-24, and 18-30 years
  - Households depending on subsistence economy

## Repository Structure

data: contains raw CSVs, shapefiles, and geocoded district data
scripts: R scripts for geocoding, cleaning, analysis, and mapping
outputs: Exported JPEG and web maps showing key indicators

## Key Insights

- Wakiso and Yumbe districts have the highest number of children aged 3–17 not in school.
- NEET rates are highest in Apaa in Northern Uganda
- Subsistence economy is heavily concentrated in Yumbe.
- Kampala, its neighbouring districts and border districts near Democratic Republic of Congo and South Sudan have high populations.

The maps in this project visualize both absolute numbers and percentages to reflect needs through the lenses of equity, equality, and ultimately, liberation. Inspired by the well-known “Equality vs. Equity vs. Liberation” illustration, this approach helps reveal not just where services are lacking, but where impact can be maximized.

- Percentages highlight areas with the highest relative need, guiding equity-based interventions that respond to disparities.

- Absolute numbers reveal where large populations are affected, which is crucial for those aiming to make big, scalable impact.

Balancing both views ensures that decisions are not only fair but strategic—addressing both systemic disadvantage and population scale. This dual perspective is essential for practitioners, policymakers, and social entrepreneurs committed to inclusive and transformative development.

## Tools Used

- R and RStudio
- Packages: `sf`, `tidyverse`, `leaflet`, `mapview`
- `LocationIQ` for geocoding
- Uganda 2024 Census Data


## Acknowledgments

Special thanks to:
- UC Berkeley and Mastercard Foundation throught the Center for African Studies
- Blum Center for Development Economies 
- Professors: Amy Janel Pickering, Daniel Wilson, Yoshika S Crider, Joyce Kisiangani, and Lewis Msasa
- Charlie Joey Hadley for the [Mapping in R LinkedIn Learning course](https://www.linkedin.com/learning-login/share?account=42798068&forceAccount=false&redirect=https%3A%2F%2Fwww.linkedin.com%2Flearning%2Fcreating-maps-with-r%3Ftrk%3Dshare_ent_url%26shareId%3D55rFytylQ%252BuR5yYPDufpyA%253D%253D)

## What’s Next

I will be sharing localized insights by my sub-county (using using ArcGis Pro and Google Earth Engine) where I grew up from so stay connected.

By Annet Kajumba 
Master of Development Engineering, UC Berkeley  
[LinkedIn Profile](https://www.linkedin.com/in/annet-kajumba2024/details/certifications/) 
annet_kajumba2024@eberkeley.edu
