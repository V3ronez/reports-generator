defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "build the report" do
      # SETUP
      file_name = "report_test.csv"
      response = ReportsGenerator.build(file_name)

      expected = %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      # ASSERTION
      assert response == expected
    end
  end

  describe "fetch_higher_cost/2" do
    test "fetch the higher cost in report with 'users'" do
      option = ["users", "foods"]
      file_name = "report_test.csv"
      report = ReportsGenerator.build(file_name)
      response = ReportsGenerator.fetch_higher_cost(report, hd(option))

      expected = {:ok, {"5", 49}}
      assert response == expected
    end

    test("fetch the higher cost in report with 'foods'") do
      option = ["users", "foods"]
      file_name = "report_test.csv"
      report = ReportsGenerator.build(file_name)
      response = ReportsGenerator.fetch_higher_cost(report, List.last(option))

      expected = {:ok, {"esfirra", 3}}
      assert response == expected
    end

    test("throw error when send invalid option to fetch") do
      option = ["users", "foods"]
      file_name = "report_test.csv"
      report = ReportsGenerator.build(file_name)
      response = ReportsGenerator.fetch_higher_cost(report, "love")

      expected = {:error, "invalid option"}
      assert response == expected
    end
  end
end
