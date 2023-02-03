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

  describe "build_report_async/1" do
    test "build a report list of files" do
      files_name = ["report_test.csv", "report_test.csv"]
      response = ReportsGenerator.build_report_async(files_name)

      expected_response =
        {:ok,
         %{
           "foods" => %{
             "açaí" => 2,
             "churrasco" => 4,
             "esfirra" => 6,
             "hambúrguer" => 4,
             "pastel" => 0,
             "pizza" => 4,
             "prato_feito" => 0,
             "sushi" => 0
           },
           "users" => %{
             "1" => 96,
             "10" => 72,
             "11" => 0,
             "12" => 0,
             "13" => 0,
             "14" => 0,
             "15" => 0,
             "16" => 0,
             "17" => 0,
             "18" => 0,
             "19" => 0,
             "2" => 90,
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
             "3" => 62,
             "30" => 0,
             "4" => 84,
             "5" => 98,
             "6" => 36,
             "7" => 54,
             "8" => 50,
             "9" => 48
           }
         }}

      assert response == expected_response
    end

    test "input any value different of a list" do
      files_name = "nubank aumenta meu limite pls"
      response = ReportsGenerator.build_report_async(files_name)

      expected_response = {:error, "please provide a list of files"}

      assert response == expected_response
    end
  end
end
