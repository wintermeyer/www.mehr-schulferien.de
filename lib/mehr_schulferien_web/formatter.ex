defmodule MehrSchulferienWeb.Formatter do

  def truncate(text, opts \\ []) do
    max_length  = opts[:max_length] || 10
    omission    = opts[:omission] || "..."

    cond do
      not String.valid?(text) ->
        text
      String.length(text) < max_length ->
        text
      true ->
        length_with_omission = max_length - String.length(omission)

        "#{String.slice(text, 0, length_with_omission)}#{omission}"
    end
  end

  def starts_to_ends_heading(starts_on, ends_on) do
    case {starts_on.month, starts_on.year, ends_on.month, ends_on.year} do
      {1, x, 12, x} -> Integer.to_string(starts_on.year)
      _ -> three_letter_month(starts_on) <> Integer.to_string(starts_on.year) <> " - " <>
           three_letter_month(ends_on) <> Integer.to_string(ends_on.year)
    end
  end

  def three_letter_month(date) do
    case date.month do
      1 -> "Jan. "
      2 -> "Feb. "
      3 -> "Mär. "
      4 -> "Apr. "
      5 -> "Mai "
      6 -> "Juni "
      7 -> "Juli "
      8 -> "Aug. "
      9 -> "Sep. "
      10 -> "Okt. "
      11 -> "Nov. "
      _ -> "Dez. "
    end
  end

  def starts_on_to_ends_on(starts_on, ends_on) do
    case starts_on.year == ends_on.year do
      true ->  Integer.to_string(starts_on.day) <> "." <>
               Integer.to_string(starts_on.month) <> ". - " <>
               Integer.to_string(ends_on.day) <> "." <>
               Integer.to_string(ends_on.month) <> "." <>
               Integer.to_string(ends_on.year)
      false -> Integer.to_string(starts_on.day) <> "." <>
               Integer.to_string(starts_on.month) <> "." <>
               Integer.to_string(starts_on.year) <> ". - " <>
               Integer.to_string(ends_on.day) <> "." <>
               Integer.to_string(ends_on.month) <> "." <>
               Integer.to_string(ends_on.year)
    end
  end

  def fill_up_month_to_have_complete_weeks(days) do
    # Fill days with empty elements for the calendar blanks in
    # the first and last line of it.
    #
    head_fill = case List.first(days).weekday do
      1 -> nil
      2 -> [nil]
      3 -> [nil,nil]
      4 -> [nil,nil,nil]
      5 -> [nil,nil,nil,nil]
      6 -> [nil,nil,nil,nil,nil]
      7 -> [nil,nil,nil,nil,nil,nil]
    end

    tail_fill = case List.last(days).weekday do
      7 -> nil
      6 -> [nil]
      5 -> [nil,nil]
      4 -> [nil,nil,nil]
      3 -> [nil,nil,nil,nil]
      2 -> [nil,nil,nil,nil,nil]
      1 -> [nil,nil,nil,nil,nil,nil]
    end

    days = case {head_fill, tail_fill} do
      {nil, nil} -> days
      {nil, _} -> Enum.concat(days, tail_fill)
      {_, nil} -> Enum.concat(head_fill, days)
      {_, _} -> Enum.concat(Enum.concat(head_fill, days), tail_fill)
    end
  end
end