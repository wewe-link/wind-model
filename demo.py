"""Small demo for the bundled HWM14 model."""

from pyhwm2014 import HWM14


def main() -> None:
    hwm = HWM14(
        alt=300.0,
        altlim=[300.0, 300.0],
        altstp=1,
        year=2023,
        day=150,
        ut=12.0,
        glat=40.0,
        glon=-105.0,
        ap=[-1, 10],
        option=1,
        verbose=False,
    )

    print("HWM14 demo")
    print("Location: lat=40.0 deg, lon=-105.0 deg, alt=300.0 km")
    print("Date/time: year=2023, day=150, UT=12.0")
    print(f"Zonal wind: {hwm.Uwind[0]:.3f} m/s")
    print(f"Meridional wind: {hwm.Vwind[0]:.3f} m/s")


if __name__ == "__main__":
    main()
