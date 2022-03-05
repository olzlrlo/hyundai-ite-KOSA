package com.olzlrlo.bankappwithjdbc;

import java.util.Scanner;

public class BankApplicationWithJDBC {
	private static AccountDAOImpl accountDAO = new AccountDAOImpl();
	private static Scanner scanner = new Scanner(System.in);
	
	public static void main(String[] args) {
		boolean run = true;		
		while(run) {
			System.out.println("----------------------------------------------------------");
			System.out.println("1. 계좌 생성 | 2. 계좌 목록 | 3. 예금 | 4. 출금 | 5. 종료");
			System.out.println("----------------------------------------------------------");
			System.out.print("선택> ");
			
			int selectNo = scanner.nextInt();
			
			if(selectNo == 1) {
				createAccount();
			} else if(selectNo == 2) {
				accountList();
			} else if(selectNo == 3) {
				deposit();
			} else if(selectNo == 4) {
				withdraw();
			} else if(selectNo == 5) {
				run = false;
			}
		}
		System.out.println("프로그램을 종료합니다.");
	}

	private static void createAccount() {
		System.out.println("--------------");
		System.out.println("계좌 생성");
		System.out.println("--------------");
		
		System.out.print("계좌 번호: ");
		String ano = scanner.next();
		
		System.out.print("계좌주: ");
		String owner = scanner.next();
		
		System.out.print("초기 입금액: ");
		int balance = scanner.nextInt();

		AccountVO newAccount = new AccountVO(ano, owner, balance);
		accountDAO.accountInsert(newAccount);
	}

	private static void accountList() {
		System.out.println("--------------");
		System.out.println("계좌 목록");
		System.out.println("--------------");
		accountDAO.accountList();
	}

	private static void deposit() {
		System.out.println("--------------");
		System.out.println("예금");
		System.out.println("--------------");
		System.out.print("계좌 번호: ");
		String ano = scanner.next();
		System.out.print("예금액: ");
		int money = scanner.nextInt();
		boolean isExist = findAccount(ano);

		if(isExist == false) {
			System.out.println("결과: 계좌가 없습니다.");
			return;
		}

		AccountVO account = new AccountVO(ano, money);
		accountDAO.accountPlusUpdate(account);
		System.out.println("예금을 완료했습니다.");
	}

	private static void withdraw() {
		System.out.println("--------------");
		System.out.println("출금");
		System.out.println("--------------");
		System.out.print("계좌 번호: ");
		String ano = scanner.next();
		System.out.print("출금액: ");
		int money = scanner.nextInt();

		boolean isExist = findAccount(ano);

		if(isExist == false) {
			System.out.println("결과: 계좌가 없습니다.");
			return;
		}

		AccountVO account = new AccountVO(ano, money);
		accountDAO.accountMinusUpdate(account);
	}

	private static boolean findAccount(String ano) {
		return accountDAO.accountFindOne(ano);
	}
}