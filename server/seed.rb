require_relative 'app'

Mongoid.load!("mongoid.yml")

SELLERS = YAML::load <<EOD
---
- :name: utahlegals.com
  :url: "http://utahlegals.com/"
  :phone: 
  :scrapable: true

- :name: HallidayWatkins
  :url: "http://www.halliday-watkins.com/live/bids.htm"
  :phone: "801.355.2886"
  :scrapable: true

- :name: Lundberg
  :url: "http://www.lundbergfirm.com/new/UpcomingSales.php"
  :phone: "801.263.3400"
  :scrapable: true

- :name: ScalleyReading
  :url: "http://www.scalleyreading.net/index.php/trustee/currentTrusteeSales"
  :phone: "801.531.7870"
  :scrapable: true

- :name: SmithKnowles
  :url: "http://smithknowles.com/foreclosure_sales.asp"
  :phone: "801.476.0303"
  :scrapable: true

- :name: UtahTrustee
  :url: "http://utahtrustee.com/pending-sales.php"
  :phone: 
  :scrapable: true

- :name: Matheson
  :url: "http://www.mathesonhowell.com/foreclosures/"
  :phone: "801.363.2244"
  :scrapable: true

- :name: CooperCastle
  :url: "http://www.ccfirm.com/utah/"
  :phone: "801.302.5486"
  :scrapable: true

- :name: BoyceLawFirm
  :url: "http://boyce.wasatchit.com/upcoming-sales-utah-foreclosure-sales/"
  :phone: "801.531.8315"
  :scrapable: true

- :name: PetteyLegal
  :url: "http://petteylegal.com/foreclosure_bids.php"
  :phone: "801.984.0055"
  :scrapable: true

- :name: Woodall
  :url:
  :phone: "801.254.9450"
  :scrapable: false

- :name: Bonneville Superior Title
  :url: "http://www.bonnevillesuperior.com/"
  :phone: "801.774.5511"
  :scrapable: false

- :name: Douglas M. Monson
  :url: "http://www.rqn.com"
  :phone: "801.532.1500"
  :scrapable: false

- :name: Richard H. Reeve
  :url: "http://www.vancott.com"
  :phone: "801.394.5783"
  :scrapable: false

- :name: Richard W. Jones
  :url:
  :phone: "801.479.4777"
  :scrapable: false

- :name: RichardsBrandt
  :url: "http://www.rbmn.com/"
  :phone: "801.531.2000"
  :scrapable: false

- :name: Robert J. Hopp
  :url: "http://www.rjhopp.com"
  :phone: "801.532.2560"
  :scrapable: false

- :name: Carolyn Montgomery
  :url: "http://www.cnmlaw.com/"
  :phone: "801.530.7313"
  :scrapable: false

- :name: ParsonsBehle
  :url: "http://www.parsonsbehlelaw.com/"
  :phone: "801.532.1234"
  :scrapable: false

- :name: RicherOverholt
  :url: "http://richerandoverholt.com/"
  :phone: "801.561.4750"
  :scrapable: false

- :name: Steven R. Bailey
  :url:
  :phone: "801.479.1191"
  :scrapable: false

- :name: SmithHartvigsen
  :url: "http://www.smithhartvigsen.com/"
  :phone: "801.413.1600"
  :scrapable: false

- :name: RicherOverholt
  :url: "http://richerandoverholt.com/"
  :phone: "801.561.4750"
  :scrapable: false

- :name: W. Jeffery Fillmore
  :url: "http://www.cnmlaw.com/"
  :phone: "801.530.7310"
  :scrapable: false

- :name: Zane S. Froerer
  :url: "http://www.froererlaw.com/"
  :phone: "801.389.1533"
  :scrapable: false

- :name: James W. Anderson
  :url: "http://www.mmglegal.com/"
  :phone: "801.363.5600"
  :scrapable: false

- :name: Mountain View Title
  :url: "http://www.mvte.com/"
  :phone: "801.773.8888"
  :scrapable: false

- :name: Douglas J. Shumway
  :url: "http://www.shumwayvan.com/"
  :phone: "801.216.8885"
  :scrapable: false

- :name: Orange Title Insurance
  :url:
  :phone: "801.285.0964"
  :scrapable: false

- :name: Katharine H. Kinsman
  :url:
  :phone: "801.366.0140"
  :scrapable: false

- :name: Kyle C. Fielding
  :url: "http://www.mcdonaldfielding.com/"
  :phone: "801.792.2561"
  :scrapable: false

- :name: ROBERT KARIYA
  :url:
  :phone: "801.844.7220"
  :scrapable: false

- :name: Randall Marshall
  :url:
  :phone: "801.394.2673"
  :scrapable: false

- :name: Scott B. Mitchell
  :url:
  :phone: "801.942.7048"
  :scrapable: false

- :name: Russell S Walker
  :url:
  :phone: "801.364.1100"
  :scrapable: false

- :name: Edwin B. Parry
  :url:
  :phone: "801.397.2660"
  :scrapable: false

- :name: BRUCE L. RICHARDS
  :url:
  :phone: "801.972.0307"
  :scrapable: false

- :name: METRO NATIONAL TITLE
  :url:
  :phone: "801.363.6633"
  :scrapable: false

- :name: Joseph M.
  :url:
  :phone: "801.532.7840"
  :scrapable: false

- :name: Jeffrie L. Hollingworth
  :url:
  :phone: "801.531.8400"
  :scrapable: false

- :name: SHAFFER LAW OFFICE
  :url:
  :phone: "801.299.9453"
  :scrapable: false

- :name: JUSTIN R. BAER
  :url:
  :phone: "801.990.0500"
  :scrapable: false

- :name: Todd Bradford
  :url:
  :phone: "801.794.1016"
  :scrapable: false

- :name: Randall Benson
  :url:
  :phone: "801.838.9887"
  :scrapable: false

- :name: Thomas J. Erbin
  :url:
  :phone: "801.524.1000"
  :scrapable: false

- :name: Meridian Title Company
  :url:
  :phone: "801.264.8888"
  :scrapable: false

- :name: Daniel J. Torkelson
  :url:
  :phone: "801.532.2666"
  :scrapable: false

- :name: Thomas K. Checketts
  :url:
  :phone: "801.328.3600"
  :scrapable: false

- :name: George W. Pratt
  :url:
  :phone: "801.521.3200"
  :scrapable: false

- :name: TITAN TITLE INSURANCE
  :url:
  :phone: "801.716.4000"
  :scrapable: false

- :name: Michael S. Malmborg
  :url:
  :phone: "801.395.2424"
  :scrapable: false

- :name: Matt Wadsworth
  :url:
  :phone: "801.475.0123"
  :scrapable: false

- :name: Kyle C. Fielding
  :url:
  :phone: "801.610.0010"
  :scrapable: false

- :name: WALTER T. MERRILL
  :url:
  :phone: "801.991.2120"
  :scrapable: false

- :name: Michael Warner
  :url:
  :phone: "801.456.7076"
  :scrapable: false

- :name: Richard C. Terry
  :url:
  :phone: "801.534.0909"
  :scrapable: false

- :name: Ronald L. Dunn
  :url:
  :phone: "801.864.3800"
  :scrapable: false

- :name: Celtic Bank Corporation
  :url:
  :phone: "801.320.6588"
  :scrapable: false

- :name: Sherilyn A. Olsen
  :url:
  :phone: "801.799.5800"
  :scrapable: false

- :name: Lester A. Perry
  :url:
  :phone: "801.272.7556"
  :scrapable: false

- :name: John W. Lish
  :url:
  :phone: "801.214.8116"
  :scrapable: false

- :name: Jacob D. Anderson
  :url:
  :phone: "801.294.8100"
  :scrapable: false

- :name: DAVID J. KNOWLTON
  :url:
  :phone: "801.621.4852"
  :scrapable: false

- :name: Eagle Gate Title
  :url:
  :phone: "801.802.0995"
  :scrapable: false

- :name: Celeste C. Canning
  :url:
  :phone: "801.612.9299"
  :scrapable: false

EOD


SELLERS.each do |seller|
  s = Seller.find_or_initialize_by({name: seller[:name]})
  s.update_attributes(
    url: seller[:url],
    phone: seller[:phone],
    scrapable: seller[:scrapable]
  )
end

