defmodule CardTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  use MangoPay.Factory
  use Helper
  use MangoPay.UserFactory
  use MangoPay.BankAccountFactory
  use MangoPay.CardFactory

  setup_all do
    create_card_bis_cassette()
    :ok
  end

  test "create card" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/registration/create" do
      assert {:ok, response} = MangoPay.Card.create(card_hash())
      assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
    end

    assert response = MangoPay.Card.create!(card_hash())
    assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
  end

  test "get card" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/get" do
      assert {:ok, response} = MangoPay.Card.get(updated_card()["CardId"])
      assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
    end

    assert response = MangoPay.Card.get!(updated_card()["CardId"])
    assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
  end

  test "update card" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/update" do
      assert {:ok, response} = update_card_cassette()
      assert Poison.decode!(response.body)["Status"] == "VALIDATED"
    end

    #    assert response = update_card_cassette!()
    #    assert Poison.decode!(response.body)["Status"] == "VALIDATED"
  end

  test "all cards by fingerprints" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/fingerprint/all" do
      assert {:ok, response} = MangoPay.Card.all_by_fingerprint(created_card()["Fingerprint"])
      assert length(Poison.decode!(response.body)) > 0
    end

    assert response = MangoPay.Card.all_by_fingerprint!(created_card()["Fingerprint"])
    assert length(Poison.decode!(response.body)) > 0
  end

  test "all by user" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/user/all" do
      assert {:ok, response} = MangoPay.Card.all_by_user(created_registration_card()["UserId"])
      assert length(Poison.decode!(response.body)) > 0
    end

    assert response = MangoPay.Card.all_by_user!(created_registration_card()["UserId"])
    assert length(Poison.decode!(response.body)) > 0
  end

  test "all user by fingerprint" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/user/fingerprint/all" do
      #      assert  {:ok, response} = MangoPay.Card.all_user_by_fingerprint created_card()["Fingerprint"]
      #      assert length(Poison.decode!(response.body)) > 0
    end
  end

  test "all transaction by fingerprint" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/transaction/fingerprint/all" do
      assert {:ok, response} = MangoPay.Card.all_by_fingerprint(created_card()["Fingerprint"])
      assert length(Poison.decode!(response.body)) > 0
    end

    assert response = MangoPay.Card.all_by_fingerprint!(created_card()["Fingerprint"])
    assert length(Poison.decode!(response.body)) > 0
  end

  test "deactivate card" do
    use_cassette "#{Factories.SharedFunctions.module_name(__MODULE__)}/card/deactivate" do
      assert {:ok, response} =
               MangoPay.Card.deactivate(created_card_bis()["Id"], deactivate_card_hash())

      assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
    end

    assert response = MangoPay.Card.deactivate!(created_card()["Id"], deactivate_card_hash())
    assert Poison.decode!(response.body)["UserId"] == build(:created_user)["Id"]
  end
end
