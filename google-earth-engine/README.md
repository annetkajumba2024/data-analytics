Remote Sensing for Development: Google Earth Engine Analyses

This repository contains a collection of Google Earth Engine (GEE) scripts developed to explore how remote sensing can be harnessed to address challenges and support sustainable development in developing economies. Through various case studies, I demonstrate how publicly available geospatial datasets can be transformed into actionable insights for urban planning, environmental monitoring, climate resilience, and policy support. Remote sensing maaters as;
- it supports evidence-based decision-making in urban development, agriculture, water management, and climate adaptation
- enable long-term monitoring of environmental and socio-economic trends.
- and reduce the costs of data acquisition for governments and NGOs. 
These scripts were created as part of my learning journey in the Digital Transformation of Development, further improved by the Spatial Thoughts course. 

## Scripts in the repo

### 1️⃣ Multi-Index Analysis with Sentinel-2 (Kampala & Wakiso, 2019)

Dataset: `COPERNICUS/S2_HARMONIZED` + `FAO/GAUL_SIMPLIFIED_500m`
Purpose: compute NDVI, MNDWI, SAVI, and NDBI for assessing vegetation health, water presence, soil conditions, and urban areas.
Applications: Agricultural monitoring, water resource mapping, and urban expansion studies.

### 2️⃣ Nighttime Lights Change Detection (Kampala, May 2015 vs May 2025)

Datasets: `VIIRS Stray Light Corrected Nighttime Day/Night Band Composites` and GHS Urban Centers 
Purpose: Measure changes in economic activity and infrastructure growth before and during events like COVID-19 using nightlight intensity.
Applications: Urbanization monitoring, economic activity proxies, and disaster impact assessments.

### 3️⃣ 29-Year Maximum Temperature Time Series (Kampala, Uganda 1996-2024)

Dataset:** `IDAHO_EPSCOR/TERRACLIMATE` and GHS Urban Centers 
Purpose: chart historical maximum temperature trends (1996–2024) to identify climate variability and warming patterns.
Applications: Climate change impact analysis, agricultural planning, and disaster risk assessment.

## How These Analyses Can Be Used

* **Urban Planning Authorities:** Identify high-growth zones for targeted infrastructure investment.
* **Environmental Agencies:** Monitor water resources, vegetation health, and land degradation.
* **Climate Change Practitioners:** Assess long-term climate trends and their impact on vulnerable communities.
* **Development NGOs:** Target interventions using spatial evidence of need and change.

## Acknowledgements

* **Digital Transformation of Development (UC Berkeley, 2024) Instructors** — for shaping my understanding of how technology can address complex development challenges.
* **Neel Simpson** — for sharing the **Spatial Thoughts** course; https://spatialthoughts.com/, which has strengthened my remote sensing and GEE skills.
* **Google Earth Engine** — for providing free access to the platform and a vast collection of satellite imagery and other geospatial datasets,  including historical archives going back over 45 years.
* **Mastercard Foundation Scholars Program at UC Berkeley** — for sponsoring my graduate studies at UC Berkeley.
* **Dataset Providers & Developers** — for making their data openly available and accessible in Google Earth Engine:

  * **COPERNICUS/Sentinel-2 Harmonized** – European Space Agency (ESA) & European Commission (EC).
  * **FAO GAUL Administrative Boundaries** – Food and Agriculture Organization (FAO) of the United Nations.
  * **VIIRS Stray Light Corrected Nighttime Day/Night Band Composites** – NOAA National Centers for Environmental Information (NCEI) & NASA.
  * **GHS Urban Centers** – European Commission, Joint Research Centre (JRC).
  * **IDAHO\_EPSCOR/TERRACLIMATE** – University of Idaho, TerraClimate Team.
  * **Landsat Collections (Landsat 5 TM & Landsat 8 OLI Surface Reflectance)** – NASA & USGS Landsat Program.

