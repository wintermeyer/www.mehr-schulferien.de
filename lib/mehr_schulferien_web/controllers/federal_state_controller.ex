defmodule MehrSchulferienWeb.FederalStateController do
  use MehrSchulferienWeb, :controller

  alias MehrSchulferien.{Calendars, Display}

  # def index(conn, _params) do
  #   federal_states = Display.list_federal_states()
  #   render(conn, "index.html", federal_states: federal_states)
  # end

  def show(conn, %{"id" => id}) do
    location = Display.get_federal_state!(id)
    today = Date.utc_today()
    current_year = today.year
    current_month = today.month
    current_day = today.day
    {:ok, today_next_year} = Date.new(current_year + 1, current_month, current_day)
    {:ok, first_day_this_year} = Date.new(current_year, 1, 1)
    {:ok, last_day_in_three_years} = Date.new(current_year + 2, 12, 31)
    location_ids = Calendars.recursive_location_ids(location)

    next_12_months_periods =
      location_ids
      |> Display.get_periods_by_time(today, today_next_year, true)
      |> Enum.chunk_by(& &1.holiday_or_vacation_type.colloquial)

    next_3_years_periods =
      Display.get_periods_by_time(
        location_ids,
        first_day_this_year,
        last_day_in_three_years,
        false
      )

    next_3_years_periods = Enum.chunk_by(next_3_years_periods, & &1.starts_on.year)
    next_three_years = Enum.join([current_year, current_year + 1, current_year + 2], ", ")

    render(conn, "show.html",
      location: location,
      current_year: current_year,
      next_12_months_periods: next_12_months_periods,
      next_3_years_periods: next_3_years_periods,
      next_three_years: next_three_years
    )
  end
end
